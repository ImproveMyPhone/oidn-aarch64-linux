// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

#include "conv.h"
#include "pool.h"
#include "upsample.h"
#include "color.h"
#include "network.h"

namespace oidn {

  Network::Network(const Ref<Device>& device, const std::map<std::string, Ref<Tensor>>& weightsMap)
    : device(device),
      K(device->getTensorBlockSize()),
      weightsMap(weightsMap)
  {
  }

  void Network::execute(Progress& progress)
  {
    for (size_t i = 0; i < nodes.size(); ++i)
    {
      nodes[i]->execute();
      progress.update(1);
    }
  }

  double Network::getWorkAmount() const
  {
    return double(nodes.size());
  }

  void Network::setScratchSize(size_t size)
  {
    scratchSize = size;
    scratch = makeRef<Buffer>(device, scratchSize);
  }

  Ref<Tensor> Network::newTensor(const TensorDesc& desc, ptrdiff_t offset)
  {
    size_t absOffset = offset >= 0 ? offset : scratchSize + offset;
    return makeRef<Tensor>(scratch, desc, absOffset);
  }

  Image Network::newImage(const ImageDesc& desc, ptrdiff_t offset)
  {
    size_t absOffset = offset >= 0 ? offset : scratchSize + offset;
    return Image(scratch, desc, absOffset);
  }

  TensorDesc Network::getInputReorderDesc(const TensorDims& srcDims, int alignment)
  {
    assert(srcDims.size() == 3); // CHW

    TensorDims dstDims = srcDims;
    dstDims[0] = round_up(srcDims[0], K); // round up C
    dstDims[1] = round_up(srcDims[1], int64_t(alignment)); // round up H
    dstDims[2] = round_up(srcDims[2], int64_t(alignment)); // round up W

    TensorLayout layout = K == 16 ? TensorLayout::Chw16c : (K == 8 ? TensorLayout::Chw8c : TensorLayout::chw);
    return TensorDesc(dstDims, layout, DataType::Float32);
  }

  Ref<InputReorderNode> Network::addInputReorder(const Ref<Tensor>& dst,
                                                 const Ref<TransferFunction>& transferFunc,
                                                 bool hdr,
                                                 bool snorm)
  {
    auto node = makeRef<InputReorderNode>(device, dst, transferFunc, hdr, snorm);
    nodes.push_back(node);
    return node;
  }

  Ref<OutputReorderNode> Network::addOutputReorder(const Ref<Tensor>& src,
                                                   const Ref<TransferFunction>& transferFunc,
                                                   bool hdr,
                                                   bool snorm)
  {
    auto node = makeRef<OutputReorderNode>(device, src, transferFunc, hdr, snorm);
    nodes.push_back(node);
    return node;
  }

  TensorDesc Network::getConvDesc(const std::string& name, const TensorDesc& srcDesc)
  {
    assert(srcDesc.ndims() == 3); // CHW

    const auto& bias = weightsMap[name + ".bias"];
    TensorDims dstDims = srcDesc.dims;
    dstDims[0] = round_up(bias->dims[0], K); // dstDims[C] = round_up(OC, K)
    return TensorDesc(dstDims, srcDesc.layout, srcDesc.dataType);
  }

  Ref<Node> Network::addConv(const std::string& name,
                             const Ref<Tensor>& src,
                             const Ref<Tensor>& dst,
                             bool relu)
  {
    assert(dst->desc() == getConvDesc(name, src->desc()));

    // Get and pad the weights
    auto weights = weightsMap[name + ".weight"];
    if (weights->ndims() != 4 || weights->layout != TensorLayout::oihw)
      throw Exception(Error::InvalidOperation, "invalid convolution weights");  
    if (K > 1)
      weights = padWeights(weights);

    // Get and pad the biases
    auto bias = weightsMap[name + ".bias"];
    if (bias->ndims() != 1)
      throw Exception(Error::InvalidOperation, "invalid convolution biases");
    if (K > 1)
      bias = padBias(bias);

    // Create the convolution node
    auto node = makeRef<ConvNode>(device, src, weights, bias, dst, relu);
    nodes.push_back(node);
    return node;
  }

  TensorDesc Network::getPoolDesc(const TensorDesc& srcDesc)
  {
    assert(srcDesc.ndims() == 3); // CHW

    TensorDims dstDims = srcDesc.dims;
    dstDims[1] /= 2; // H/2
    dstDims[2] /= 2; // W/2
    return TensorDesc(dstDims, srcDesc.layout, srcDesc.dataType);
  }

  Ref<Node> Network::addPool(const Ref<Tensor>& src,
                             const Ref<Tensor>& dst)
  {
    assert(dst->desc() == getPoolDesc(src->desc()));

    auto node = makeRef<PoolNode>(device, src, dst);
    nodes.push_back(node);
    return node;
  }

  TensorDesc Network::getUpsampleDesc(const TensorDesc& srcDesc)
  {
    assert(srcDesc.ndims() == 3); // CHW

    TensorDims dstDims = srcDesc.dims;
    dstDims[1] *= 2; // H*2
    dstDims[2] *= 2; // W*2
    return TensorDesc(dstDims, srcDesc.layout, srcDesc.dataType);
  }

  Ref<Node> Network::addUpsample(const Ref<Tensor>& src,
                                 const Ref<Tensor>& dst)
  {
    assert(dst->desc() == getUpsampleDesc(src->desc()));

    auto node = makeRef<UpsampleNode>(device, src, dst);
    nodes.push_back(node);
    return node;
  }

  TensorDesc Network::getConcatDesc(const std::vector<TensorDesc>& srcDescs)
  {
    assert(!srcDescs.empty());
    assert(srcDescs[0].ndims() == 3); // CHW

    TensorDims dstDims = srcDescs[0].dims;
    for (size_t i = 1; i < srcDescs.size(); ++i)
    {
      assert(srcDescs[i].ndims() == 3); // CHW
      assert(srcDescs[i].dims[1] == srcDescs[0].dims[1]); // H
      assert(srcDescs[i].dims[2] == srcDescs[0].dims[2]); // W
      assert(srcDescs[i].layout == srcDescs[0].layout);
      assert(srcDescs[i].dataType == srcDescs[0].dataType);
      dstDims[0] += srcDescs[i].dims[0]; // C
    }
    return TensorDesc(dstDims, srcDescs[0].layout, srcDescs[0].dataType);
  }

  void Network::finalize()
  {
    // Compute the size of the scratch memory for the nodes
    size_t nodeScratchSize = 0;
    for (const auto& node : nodes)
      nodeScratchSize = max(nodeScratchSize, node->getScratchSize());

    // Allocate the scratch memory for the nodes
    TensorDims nodeScratchDims = { int64_t(nodeScratchSize) };
    auto nodeScratch = makeRef<Tensor>(device, nodeScratchDims, TensorLayout::x, DataType::UInt8);

    // Set the scratch memory for the nodes
    for (auto& node : nodes)
      node->setScratch(nodeScratch);

    // Free the weights
    weightsMap.clear();

    // Print statistics
    if (device->isVerbose(2))
    {
      const size_t totalScratchSize = scratchSize + nodeScratchSize;
      std::cout << "Tensor scratch bytes: " << scratchSize << std::endl;
      std::cout << "Node scratch bytes  : " << nodeScratchSize << std::endl;
      std::cout << "Total scratch bytes : " << totalScratchSize << std::endl;
    }
  }

  Ref<Tensor> Network::padWeights(const Ref<Tensor>& src)
  {
    assert(src->layout == TensorLayout::oihw);

    const int64_t O1 = src->dims[0];
    const int64_t I1 = src->dims[1];
    const int64_t O2 = round_up(O1, K);
    const int64_t I2 = round_up(I1, K);
    const int64_t H = src->dims[2];
    const int64_t W = src->dims[3];

    TensorDims dstDims = {O2, I2, H, W};
    if (dstDims == src->dims)
      return src;

    Ref<Tensor> dst = makeRef<Tensor>(device, dstDims, TensorLayout::oihw, DataType::Float32);

    for (int64_t o = 0; o < O2; ++o)
    {
      for (int64_t i = 0; i < I2; ++i)
      {
        for (int64_t h = 0; h < H; ++h)
        {
          for (int64_t w = 0; w < W; ++w)
          {
            float value;
            if (o < O1 && i < I1)
              value = src->get<float>(o, i, h, w);
            else
              value = 0; // padding

            dst->get<float>(o, i, h, w) = value;
          }
        }
      }
    }

    return dst;
  }

  Ref<Tensor> Network::padBias(const Ref<Tensor>& src)
  {
    assert(src->layout == TensorLayout::x);

    const int64_t X1 = src->dims[0];
    const int64_t X2 = round_up(X1, K);

    if (X2 == X1)
      return src;

    Ref<Tensor> dst = makeRef<Tensor>(device, TensorDims({X2}), TensorLayout::x, DataType::Float32);

    for (int64_t x = 0; x < X1; ++x)
      dst->get<float>(x) = src->get<float>(x);

    for (int64_t x = X1; x < X2; ++x)
      dst->get<float>(x) = 0; // padding

    return dst;
  }

} // namespace oidn
