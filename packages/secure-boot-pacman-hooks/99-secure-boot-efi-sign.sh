#!/bin/bash

# signs all linux/systemd/BOOTX64 efi files, except your signing keys to be in /etc/efi-keys
find /boot/EFI/ -type f \( -iname '*linux*efi' -o -iname 'systemd-bootx64.efi' -o -iname 'BOOTX64.EFI' \)  -exec /usr/bin/sh -c 'if ! /usr/bin/sbverify --list {} 2>/dev/null | /usr/bin/grep -q "signature certificates"; then echo "-> Signing $1"; /usr/bin/sbsign --key /etc/efi-keys/db.key --cert /etc/efi-keys/db.crt --output "$1" "$1"; fi' _ {} \;
