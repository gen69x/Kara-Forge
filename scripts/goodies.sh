#!/bin/bash
set -euo pipefail

DEVICE="$1"
VARIANT="$2"

source config.env
source scripts/common.sh

log "=== Applying BakaSU + SuSFS for $DEVICE ($VARIANT) ==="

if [ "$VARIANT" != "ksu" ]; then
  log "Variant $VARIANT → skip KSU/SuSFS"
  exit 0
fi

# Pastikan folder drivers/kernelsu ada
mkdir -p drivers/kernelsu

# Buat Kconfig jika belum ada
if [ ! -f drivers/kernelsu/Kconfig ]; then
  log "Creating drivers/kernelsu/Kconfig"
  cat > drivers/kernelsu/Kconfig << 'EOF'
menu "KernelSU"

config KSU
	bool "KernelSU support"
	depends on OVERLAY_FS
	default y

config KSU_MANUAL_HOOK
	bool "Manual Hook mode"
	depends on KSU
	default y

config KSU_DEBUG
	bool "KernelSU debug mode"
	depends on KSU
	default n

config KSU_SUSFS
	bool "SuSFS support"
	depends on KSU
	default y

config KSU_SUSFS_SUS_PATH
	bool "SuSFS SUS_PATH"
	depends on KSU_SUSFS
	default y

config KSU_SUSFS_SUS_MOUNT
	bool "SuSFS SUS_MOUNT"
	depends on KSU_SUSFS
	default y

config KSU_SUSFS_SUS_KSTAT
	bool "SuSFS SUS_KSTAT"
	depends on KSU_SUSFS
	default y

config KSU_SUSFS_SUS_KSTATFS
	bool "SuSFS SUS_KSTATFS"
	depends on KSU_SUSFS
	default y

config KSU_SUSFS_TRY_UMOUNT
	bool "SuSFS TRY_UMOUNT"
	depends on KSU_SUSFS
	default y

config KSU_SUSFS_SPOOF_UNAME
	bool "SuSFS SPOOF_UNAME"
	depends on KSU_SUSFS
	default y

config KSU_SUSFS_ENABLE_LOG
	bool "SuSFS enable log"
	depends on KSU_SUSFS
	default n

endmenu
EOF
fi

# Enable configs di defconfig
DEFCONFIG=$(jq -r ".[\"$DEVICE\"].defconfig" devices/$DEVICE.json)
log "Enabling KSU/SuSFS configs in $DEFCONFIG"

scripts/config --file arch/arm64/configs/$DEFCONFIG \
  --enable CONFIG_KSU \
  --enable CONFIG_KSU_MANUAL_HOOK \
  --enable CONFIG_KSU_SUSFS \
  --enable CONFIG_KSU_SUSFS_SUS_PATH \
  --enable CONFIG_KSU_SUSFS_SUS_MOUNT \
  --enable CONFIG_KSU_SUSFS_SUS_KSTAT \
  --enable CONFIG_KSU_SUSFS_SUS_KSTATFS \
  --enable CONFIG_KSU_SUSFS_TRY_UMOUNT \
  --enable CONFIG_KSU_SUSFS_SPOOF_UNAME || true

log "Goodies applied"
