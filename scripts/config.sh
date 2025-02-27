#!/bin/bash

if [ -z "${SCRIPT_DIR}" ]; then
  echo "WARNING: \${SCRIPT_DIR} is not set properly"
  exit 1
fi

ROOT="$(cd "${SCRIPT_DIR}/.."; pwd)"

LIBCXX_SRC="${ROOT}/libcxx"
LIBCXXABI_SRC="${ROOT}/libcxxabi"
LIBUNWIND_SRC="${ROOT}/libunwind"

if [ "${CROSS_COMPILING}" = "loongarch64" ]; then
  OBJ_DIR="${ROOT}/objs-loongarch64"
  OUT_DIR="${ROOT}/out-loongarch64"
else
  OBJ_DIR="${ROOT}/objs"
  OUT_DIR="${ROOT}/out"
fi

LIBCXX_OBJ="${OBJ_DIR}/libcxx"
LIBCXXABI_OBJ="${OBJ_DIR}/libcxxabi"
LIBCXXABI_UNITTEST_OUT="${OUT_DIR}/unittests"
LIBUNWIND_OBJ="${OBJ_DIR}/libunwind"

if [ -z "${CC}" ]; then
  export CC="clang"
fi

if [ -z "${CXX}" ]; then
  export CXX="clang++"
fi
