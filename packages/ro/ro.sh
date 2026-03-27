#!/bin/sh
set -xe
mount -o remount,ro /
mount -o remount,ro /boot
set +x
echo "=== OS is in Read-Only mode ==="
