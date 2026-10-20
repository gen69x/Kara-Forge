#!/bin/bash
set -euo pipefail

DEVICE="$1"
VARIANT="$2"

source scripts/common.sh
source scripts/env.sh "$DEVICE"

DEFCONFIG=$(jq -r ".[\"$DEVICE\"].defconfig" devices/$DEVICE.json)
JOBS=4

log "=== Compiling $DEVICE ($VARIANT) with $JOBS jobs ==="
log "Defconfig: $DEFCONFIG"

rm -rf out
mkdir -p out

make O=out ARCH=arm64 $DEFCONFIG

make -j${JOBS} O=out ARCH=arm64 \
  CC="ccache clang" \
  CROSS_COMPILE=aarch64-linux-gnu- \
  CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
  LD=ld.lld AR=llvm-ar NM=llvm-nm \
  OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip \
  2>&1 | tee ${DEVICE}-${VARIANT}-build.log

# Cari image
IMG=""
for f in out/arch/arm64/boot/Image.gz-dtb out/arch/arm64/boot/Image.gz out/arch/arm64/boot/Image; do
  [ -f "$f" ] && IMG="$f" && break
done

[ -z "$IMG" ] && err "Image tidak ditemukan!"

log "Found image: $IMG"

# Package AnyKernel3
cp "$IMG" AnyKernel3/
[ -f out/arch/arm64/boot/dtbo.img ] && cp out/arch/arm64/boot/dtbo.img AnyKernel3/

cd AnyKernel3
ZIP_NAME="Kara-BakaSU-onclite-$(date +%Y%m%d-%H%M).zip"
zip -r9 "../$ZIP_NAME" . -x "*.git*" "README.md"
cd ..

log "Packaged: $ZIP_NAME"
