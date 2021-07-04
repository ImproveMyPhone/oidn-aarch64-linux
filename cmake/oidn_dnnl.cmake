## Copyright 2009-2021 Intel Corporation
## SPDX-License-Identifier: Apache-2.0
## This file is modified, see
## https://github.com/ImproveMyPhone/oidn-aarch64-linux
## for more details.

set(DNNL_VERSION_MAJOR 2)
set(DNNL_VERSION_MINOR 3)
set(DNNL_VERSION_PATCH 0)
set(DNNL_VERSION_HASH  "N/A")

set(DNNL_CPU_RUNTIME "TBB")
set(DNNL_CPU_THREADING_RUNTIME "TBB")
set(DNNL_GPU_RUNTIME "NONE")

configure_file(
  "${PROJECT_SOURCE_DIR}/mkl-dnn/include/oneapi/dnnl/dnnl_config.h.in"
  "${PROJECT_BINARY_DIR}/mkl-dnn/include/oneapi/dnnl/dnnl_config.h"
)
configure_file(
  "${PROJECT_SOURCE_DIR}/mkl-dnn/include/oneapi/dnnl/dnnl_version.h.in"
  "${PROJECT_BINARY_DIR}/mkl-dnn/include/oneapi/dnnl/dnnl_version.h"
)

file(GLOB_RECURSE DNNL_SOURCES
  mkl-dnn/src/common/batch_normalization.cpp
  mkl-dnn/src/common/binary.cpp
  mkl-dnn/src/common/bfloat16.[ch]pp
  mkl-dnn/src/common/broadcast_strategy.[ch]pp
  mkl-dnn/src/common/concat.cpp
  mkl-dnn/src/common/convolution.cpp
  mkl-dnn/src/common/convolution_pd.[ch]pp
  mkl-dnn/src/common/deconvolution.cpp
  mkl-dnn/src/common/dnnl_debug.cpp
  mkl-dnn/src/common/dnnl_debug_autogenerated.cpp
  mkl-dnn/src/common/dnnl_thread.[ch]pp
  mkl-dnn/src/common/eltwise.cpp
  mkl-dnn/src/common/engine.[ch]pp
  mkl-dnn/src/common/gemm.cpp
  mkl-dnn/src/common/inner_product.cpp
  mkl-dnn/src/common/ittnotify.[ch]pp
  mkl-dnn/src/common/layer_normalization.cpp
  mkl-dnn/src/common/lrn.cpp
  mkl-dnn/src/common/matmul.cpp
  mkl-dnn/src/common/memory.[ch]pp
  mkl-dnn/src/common/memory_debug.[ch]pp
  mkl-dnn/src/common/memory_desc_wrapper.[ch]pp
  mkl-dnn/src/common/memory_storage.[ch]pp
  mkl-dnn/src/common/memory_tracking.[ch]pp
  mkl-dnn/src/common/memory_zero_pad.cpp
  mkl-dnn/src/common/pooling.cpp
  mkl-dnn/src/common/prelu.cpp
  mkl-dnn/src/common/prelu_pd.[ch]pp
  mkl-dnn/src/common/primitive.[ch]pp
  mkl-dnn/src/common/primitive_attr.[ch]pp
  mkl-dnn/src/common/primitive_cache.[ch]pp
  mkl-dnn/src/common/primitive_desc.[ch]pp
  mkl-dnn/src/common/primitive_exec_types.[ch]pp
  mkl-dnn/src/common/primitive_hashing.[ch]pp
  mkl-dnn/src/common/primitive_iterator.[ch]pp
  mkl-dnn/src/common/query.cpp
  mkl-dnn/src/common/reduction.cpp
  mkl-dnn/src/common/reorder.[ch]pp
  mkl-dnn/src/common/resampling.cpp
  mkl-dnn/src/common/rnn.[ch]pp
  mkl-dnn/src/common/rw_mutex.[ch]pp
  mkl-dnn/src/common/scratchpad.[ch]pp
  mkl-dnn/src/common/scratchpad_debug.[ch]pp
  mkl-dnn/src/common/shuffle.cpp
  mkl-dnn/src/common/softmax.cpp
  mkl-dnn/src/common/stream.[ch]pp
  mkl-dnn/src/common/sum.cpp
  mkl-dnn/src/common/utils.[ch]pp
  mkl-dnn/src/common/verbose.[ch]pp
  mkl-dnn/src/cpu/aarch64/cpu_barrier.[ch]pp
  mkl-dnn/src/cpu/aarch64/cpu_isa_traits.[ch]pp
  mkl-dnn/src/cpu/aarch64/cpu_reducer.[ch]pp
  mkl-dnn/src/cpu/aarch64/injectors/jit_uni_eltwise_injector.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_sve_512_1x1_conv_kernel.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_sve_512_1x1_convolution.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_sve_512_conv_kernel.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_sve_512_convolution.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_sve_512_x8s8s32x_conv_kernel.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_sve_512_x8s8s32x_convolution.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_batch_normalization.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_batch_normalization_s8.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_dw_conv_kernel_f32.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_dw_convolution.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_eltwise.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_eltwise_int.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_i8i8_pooling.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_pool_kernel.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_pooling.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_reorder.[ch]pp
  mkl-dnn/src/cpu/aarch64/jit_uni_reorder_utils.cpp
  mkl-dnn/src/cpu/aarch64/jit_uni_softmax.[ch]pp
  mkl-dnn/src/cpu/aarch64/xbyak_aarch64/src/xbyak_aarch64_impl.cpp
  mkl-dnn/src/cpu/bfloat16.cpp
  mkl-dnn/src/cpu/binary_injector_utils.[ch]pp
  mkl-dnn/src/cpu/cpu_batch_normalization_list.cpp
  mkl-dnn/src/cpu/cpu_batch_normalization_utils.[ch]pp
  mkl-dnn/src/cpu/cpu_binary_list.cpp
  mkl-dnn/src/cpu/cpu_concat.cpp
  mkl-dnn/src/cpu/cpu_convolution_list.cpp
  mkl-dnn/src/cpu/cpu_deconvolution_list.cpp
  mkl-dnn/src/cpu/cpu_eltwise_list.cpp
  mkl-dnn/src/cpu/cpu_engine.[ch]pp
  mkl-dnn/src/cpu/cpu_inner_product_list.cpp
  mkl-dnn/src/cpu/cpu_layer_normalization_list.cpp
  mkl-dnn/src/cpu/cpu_lrn_list.cpp
  mkl-dnn/src/cpu/cpu_pooling_list.cpp
  mkl-dnn/src/cpu/cpu_prelu_list.cpp
  mkl-dnn/src/cpu/cpu_reduction_list.cpp
  mkl-dnn/src/cpu/cpu_resampling_list.cpp
  mkl-dnn/src/cpu/cpu_rnn_list.cpp
  mkl-dnn/src/cpu/cpu_shuffle_list.cpp
  mkl-dnn/src/cpu/cpu_softmax_list.cpp
  mkl-dnn/src/cpu/cpu_sum.cpp
  mkl-dnn/src/cpu/gemm/f32/gemm_utils_f32.[ch]pp
  mkl-dnn/src/cpu/gemm/f32/ref_gemm_f32.[ch]pp
  mkl-dnn/src/cpu/gemm/gemm.[ch]pp
  mkl-dnn/src/cpu/gemm/gemm_pack.[ch]pp
  mkl-dnn/src/cpu/gemm/s8x8s32/ref_gemm_s8x8s32.[ch]pp
  mkl-dnn/src/cpu/gemm/s8x8s32/simple_gemm_s8s8s32.[ch]pp
  mkl-dnn/src/cpu/gemm_convolution.[ch]pp
  mkl-dnn/src/cpu/gemm_convolution_utils.[ch]pp
  mkl-dnn/src/cpu/gemm_inner_product.[ch]pp
  mkl-dnn/src/cpu/gemm_inner_product_utils.[ch]pp
  mkl-dnn/src/cpu/gemm_x8s8s32x_conv_zp_src_pad_comp.[ch]pp
  mkl-dnn/src/cpu/gemm_x8s8s32x_convolution.[ch]pp
  mkl-dnn/src/cpu/gemm_x8s8s32x_convolution_utils.[ch]pp
  mkl-dnn/src/cpu/gemm_x8s8s32x_inner_product.[ch]pp
  mkl-dnn/src/cpu/jit_utils/jit_utils.[ch]pp
  mkl-dnn/src/cpu/jit_utils/linux_perf/linux_perf.[ch]pp
  mkl-dnn/src/cpu/matmul/cpu_matmul_list.cpp
  mkl-dnn/src/cpu/matmul/gemm_bf16_matmul.[ch]pp
  mkl-dnn/src/cpu/matmul/gemm_f32_matmul.[ch]pp
  mkl-dnn/src/cpu/matmul/gemm_x8s8s32x_matmul.[ch]pp
  mkl-dnn/src/cpu/matmul/ref_matmul.[ch]pp
  mkl-dnn/src/cpu/nchw_pooling.[ch]pp
  mkl-dnn/src/cpu/ncsp_batch_normalization.[ch]pp
  mkl-dnn/src/cpu/nhwc_pooling.[ch]pp
  mkl-dnn/src/cpu/nspc_batch_normalization.[ch]pp
  mkl-dnn/src/cpu/platform.[ch]pp
  mkl-dnn/src/cpu/primitive_attr_postops.[ch]pp
  mkl-dnn/src/cpu/ref_batch_normalization.[ch]pp
  mkl-dnn/src/cpu/ref_binary.[ch]pp
  mkl-dnn/src/cpu/ref_convolution.[ch]pp
  mkl-dnn/src/cpu/ref_deconvolution.[ch]pp
  mkl-dnn/src/cpu/ref_eltwise.[ch]pp
  mkl-dnn/src/cpu/ref_inner_product.[ch]pp
  mkl-dnn/src/cpu/ref_layer_normalization.[ch]pp
  mkl-dnn/src/cpu/ref_lrn.[ch]pp
  mkl-dnn/src/cpu/ref_pooling.[ch]pp
  mkl-dnn/src/cpu/ref_prelu.[ch]pp
  mkl-dnn/src/cpu/ref_reduction.[ch]pp
  mkl-dnn/src/cpu/ref_resampling.[ch]pp
  mkl-dnn/src/cpu/ref_shuffle.[ch]pp
  mkl-dnn/src/cpu/ref_softmax.[ch]pp
  mkl-dnn/src/cpu/reorder/cpu_reorder.[ch]pp
  mkl-dnn/src/cpu/reorder/cpu_reorder_comp_bf16_s8.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_comp_f32_s8.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_comp_s8_s8.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_bf16.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_f16.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_f32_bf16.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_f32_f16.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_f32_f32.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_f32_s32.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_f32_s8.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_f32_u8.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_s32.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_s8.cpp
  mkl-dnn/src/cpu/reorder/cpu_reorder_regular_u8.cpp
  mkl-dnn/src/cpu/rnn/brgemm_cell_common.cpp
  mkl-dnn/src/cpu/rnn/cell_common.cpp
  mkl-dnn/src/cpu/rnn/cell_gru.cpp
  mkl-dnn/src/cpu/rnn/cell_gru_lbr.cpp
  mkl-dnn/src/cpu/rnn/ref_postgemm_gru.cpp
  mkl-dnn/src/cpu/rnn/ref_postgemm_gru_lbr.cpp
  mkl-dnn/src/cpu/rnn/ref_postgemm_lstm.cpp
  mkl-dnn/src/cpu/rnn/ref_postgemm_lstm_projection.cpp
  mkl-dnn/src/cpu/rnn/ref_postgemm_rnn.cpp
  mkl-dnn/src/cpu/rnn/ref_rnn.[ch]pp
  mkl-dnn/src/cpu/rnn/rnn_utils.[ch]pp
  mkl-dnn/src/cpu/simple_concat.[ch]pp
  mkl-dnn/src/cpu/simple_layer_normalization.[ch]pp
  mkl-dnn/src/cpu/simple_layer_normalization_kernels.[ch]pp
  mkl-dnn/src/cpu/simple_resampling.[ch]pp
  mkl-dnn/src/cpu/simple_sum.[ch]pp
  mkl-dnn/src/cpu/zero_point_utils.[ch]pp
)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  file(GLOB DNNL_SOURCES_BIGOBJ
    mkl-dnn/src/cpu/cpu_engine.cpp
    mkl-dnn/src/cpu/cpu_reorder.cpp
  )
  set_source_files_properties(${DNNL_SOURCES_BIGOBJ} PROPERTIES COMPILE_FLAGS "/bigobj")
endif()

add_library(dnnl STATIC ${DNNL_SOURCES})

target_include_directories(dnnl
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/mkl-dnn/include>
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/mkl-dnn/include>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/mkl-dnn/src>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/mkl-dnn/src/common>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/mkl-dnn/src/cpu>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/mkl-dnn/src/cpu/xbyak>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/mkl-dnn/src/cpu/aarch64/xbyak_aarch64/xbyak_aarch64/>
)

target_compile_definitions(dnnl
  PUBLIC
    -DDNNL_ENABLE_CONCURRENT_EXEC -DDNNL_AARCH64=1 -DDNNL_ENABLE_CPU_ISA_HINTS -DDNNL_ENABLE_MAX_CPU_ISA
)

set(DNNL_COMPILE_OPTIONS "")
if(WIN32 AND CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
  # Correct 'jnl' macro/jit issue
  list(APPEND DNNL_COMPILE_OPTIONS "/Qlong-double")
endif()
target_compile_options(dnnl PRIVATE ${DNNL_COMPILE_OPTIONS})

target_link_libraries(dnnl
  PUBLIC
    ${CMAKE_THREAD_LIBS_INIT}
    TBB
)
if(UNIX AND NOT APPLE)
  # Not every compiler adds -ldl automatically
  target_link_libraries(dnnl PUBLIC ${CMAKE_DL_LIBS})
endif()

if(OIDN_STATIC_LIB)
  install(TARGETS dnnl
    EXPORT
      ${PROJECT_NAME}_Export
    ARCHIVE
      DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT devel
  )
endif()
