#!/bin/bash -e

if [ "$#" != 1 ]; then
    echo "Usage: ./create-recovery.sh <kernel-version>"
    echo "      e.g., ./create-recovery.sh /path/to/actual/kernel"
    exit 0
fi

echo "Making a recovery image with $1"

rm -rf kernel-with-recovery.img

# Get the file size of the bootloader
if [[ "$(uname)" = "Darwin" ]]; then
    file_size=$(stat -f %z "bootloader/bootloader")
else
    file_size=$(stat -c %s "bootloader/bootloader")
fi

# Create an empty recovery image
dd if=/dev/zero of=kernel-with-recovery.img bs=16777216 count=1

# Add the bootloader and the actual kernel to the image
dd if=bootloader/bootloader of=kernel-with-recovery.img conv=notrunc seek=0
dd if=$1 of=kernel-with-recovery.img conv=notrunc bs=1 seek=5242880

# (Optional) Add recovery kernel if needed
# dd if=recovery-kernel of=kernel-with-recovery.img conv=notrunc bs=1 seek=5242880

