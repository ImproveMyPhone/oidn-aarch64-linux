## Copyright 2009-2021 Intel Corporation
## SPDX-License-Identifier: Apache-2.0
## Modified by ImproveMyPhone
## https://github.com/ImproveMyPhone/oidn-aarch64-linux
## Changelog:
## 2021-08-01T00:00:00.000Z Initial Android support

add_subdirectory(utils)

macro(oidn_add_app APP_NAME)
  add_executable(${APP_NAME} ${ARGN} ${OIDN_RESOURCE})
  if (${APP_NAME} STREQUAL "oidnTest" AND ANDROID)
  target_link_libraries(${APP_NAME} PRIVATE common utils -llog ${PROJECT_NAME})
  else()
  target_link_libraries(${APP_NAME} PRIVATE common utils ${PROJECT_NAME})
  endif()
  install(TARGETS ${APP_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT apps)
endmacro()

oidn_add_app(oidnDenoise oidnDenoise.cpp)
oidn_add_app(oidnBenchmark oidnBenchmark.cpp)
oidn_add_app(oidnTest oidnTest.cpp catch.hpp)