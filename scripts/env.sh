#!/bin/bash
set -euo pipefail

DEVICE="$1"
source config.env

export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="${KBUILD_BUILD_USER:-gen69x}"
export KBUILD_BUILD_HOST="${KBUILD_BUILD_HOST:-kara-build}"

# Toolchain
export PATH="$GITHUB_WORKSPACE/clang/bin:$PATH"
export CC="ccache clang"
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
