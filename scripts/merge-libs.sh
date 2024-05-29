#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
source "${SCRIPT_DIR}/config.sh"

AR="${CROSS_TOOLS_DIR}/bin/loongarch64-unknown-linux-gnu-ar"

pushd "${OUT_DIR}/lib"

rm -rf cxx/
mkdir -p cxx/ && pushd cxx/
${AR} x ../libc++.a
popd

mkdir -p cxxabi/ && pushd cxxabi/
${AR} x ../libc++abi.a
popd

mkdir -p fs/ && pushd fs/
${AR} x ../libc++fs.a
popd

mkdir -p exp/ && pushd exp/
${AR} x ../libc++experimental.a
popd

rm libc++.a
${AR} Dqc libc++.a cxx/* cxxabi/* fs/* exp/*

popd
