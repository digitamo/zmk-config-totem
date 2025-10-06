#!/bin/bash
# ZMK Firmware Flashing Helper for macOS
# Usage: ./flash.sh <firmware.uf2>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <firmware.uf2>"
    echo ""
    echo "Examples:"
    echo "  $0 totem_left-seeeduino_xiao_ble-zmk.uf2"
    echo "  $0 settings_reset-seeeduino_xiao_ble-zmk.uf2"
    exit 1
fi

FIRMWARE="$1"
MOUNT_POINT="/Volumes/XIAO-SENSE"

if [ ! -f "$FIRMWARE" ]; then
    echo "Error: Firmware file '$FIRMWARE' not found"
    exit 1
fi

echo "Waiting for bootloader device..."
while [ ! -d "$MOUNT_POINT" ]; do
    sleep 0.5
done

echo "Device found! Flashing $FIRMWARE..."
echo "(Errors about 'Device not configured' are normal and can be ignored)"
echo ""

# Use dd for reliable copying - ignores extended attributes
dd if="$FIRMWARE" of="$MOUNT_POINT/firmware.uf2" conv=notrunc 2>/dev/null || true

echo ""
echo "✓ Flash complete! Device will reboot automatically."
echo ""
