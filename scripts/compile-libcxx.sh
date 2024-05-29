#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
source "${SCRIPT_DIR}/config.sh"

export LDFLAGS="-L${OUT_DIR}/lib"

mkdir -p "${LIBCXX_OBJ}"
cd "${LIBCXX_OBJ}"

EXTRA_CXX_FLAGS="-D__Fuchsia__ -I${OUT_DIR}/include"

if [ -z "${CROSS_COMPILING}" ]; then
  CMAKE_FLAGS=(
    "-DCMAKE_INSTALL_PREFIX=${OUT_DIR}"
    "-DCMAKE_CXX_FLAGS=${EXTRA_CXX_FLAGS}"
  )
elif [ "${CROSS_COMPILING}" = "loongarch64" ]; then
  # HACK: find cross compiling system include path
  SYSTEM_INCLUDE="${CROSS_TOOLS_DIR}/target/usr/include"
  if [ -d "${SYSTEM_INCLUDE}" ]; then
    EXTRA_CXX_FLAGS+=" -isystem ${SYSTEM_INCLUDE}"
  fi

  CMAKE_FLAGS=(
    "-DCMAKE_SYSTEM_PROCESSOR=loongarch64"
    "-DCMAKE_SYSTEM_NAME=Fuchsia"
    "-DCMAKE_CROSSCOMPILING=True"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=${OUT_DIR}"
    "-DCMAKE_CXX_FLAGS=${EXTRA_CXX_FLAGS}"
  )
fi

CMAKE_FLAGS+=(
  "-DLIBCXX_CXX_ABI=libcxxabi"
  "-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${LIBCXXABI_SRC}/include"
)

cmake -G "Ninja" "${CMAKE_FLAGS[@]}" "${LIBCXX_SRC}"

ninja -v && ninja install -v
