https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-raspberry-pi4/

First make sure the eeprom is updated, use raspian/rpi imager to do it.

# EDK2 boot, devicetree doesn't work currently, so no GPIO (HATs) will work

On different computer with sd card inserted:
```sh
sudo docker run -i --rm quay.io/coreos/butane:release < rpi4.bu > rpi4.ign

fdiskl # find /dev/sdXXX value used below
FCOSDISK=/dev/sdXXX
STREAM=stable
sudo coreos-installer install -a aarch64 -s $STREAM -i rpi4.ign $FCOSDISK

FCOSEFIPARTITION=$(lsblk $FCOSDISK -J -oLABEL,PATH  | jq -r '.blockdevices[] | select(.label == "EFI-SYSTEM")'.path)
mkdir /tmp/FCOSEFIpart
sudo mount $FCOSEFIPARTITION /tmp/FCOSEFIpart
pushd /tmp/FCOSEFIpart
VERSION=v1.40 # use latest one from https://github.com/pftf/RPi4/releases
sudo curl -LO https://github.com/pftf/RPi4/releases/download/${VERSION}/RPi4_UEFI_Firmware_${VERSION}.zip
sudo unzip RPi4_UEFI_Firmware_${VERSION}.zip
sudo rm RPi4_UEFI_Firmware_${VERSION}.zip
popd
sudo umount /tmp/FCOSEFIpart
sync
```

put sd card into rpi4 and turn it on

hit esc, cpu settings -> set to 1800. Eventually we want to go to rpi settings and switch from ACPI to DeviceTree, but it won't boot if we do that right now

Device tree doesn't seem to work, so lets use uboot I guess

# uboot

```sh
# prep ignition
sudo docker run -i --rm quay.io/coreos/butane:release < rpi4-initial.bu > rpi4-initial.ign

# prep uboot
sudo mkdir -p /tmp/RPi4boot/boot/efi # need's to be sudo so the perms are correct

## docker based approach
### this should match your FCOS release version
RELEASE=41 # The target Fedora Release. Use the same one that current FCOS is based on.
sudo docker run -it --rm -v /tmp/RPi4boot:/tmp/RPi4boot fedora:$RELEASE /bin/bash

### inside docker
# see https://github.com/coreos/fedora-coreos-docs/pull/697 for why dnf4
dnf install -y cpio dnf4
sudo dnf4 install -y --downloadonly --release=41 --forcearch=aarch64 --destdir=/tmp/RPi4boot/ uboot-images-armv8 bcm283x-firmware bcm283x-overlays
#doesn't download dependencies: dnf download --forcearch=aarch64 --destdir=/tmp/RPi4boot/ uboot-images-armv8 bcm283x-firmware bcm283x-overlays
for rpm in /tmp/RPi4boot/*rpm; do rpm2cpio $rpm | sudo cpio -idmv -D /tmp/RPi4boot/; done
mv /tmp/RPi4boot/usr/share/uboot/rpi_arm64/u-boot.bin /tmp/RPi4boot/boot/efi/rpi-u-boot.bin

# You can modify /tmp/RPi4boot/boot/efi/config.txt as required.
# For example, if you want to enable HATs that don't work when bluetooth is enabled, add `dtoverlay=disable-bt` at the bottom.
sudo -e /tmp/RPi4boot/boot/efi/config.txt
echo 'dtoverlay=disable-bt' | sudo tee -a /tmp/RPi4boot/boot/efi/config.txt

# install coreos
fdisk -l # find /dev/sdXXX value used below
FCOSDISK=/dev/sdXXX
STREAM=stable
sudo docker run --pull=always --privileged --rm \
-v /dev:/dev -v /run/udev:/run/udev \
quay.io/coreos/coreos-installer:release \
install -a aarch64 -s $STREAM -i rpi4-initial.ign --append-karg nomodeset $FCOSDISK --save-partlabel var

# copy over uboot
FCOSEFIPARTITION=$(lsblk $FCOSDISK -J -oLABEL,PATH  | jq -r '.blockdevices[] | select(.label == "EFI-SYSTEM")'.path)
mkdir /tmp/FCOSEFIpart
sudo mount $FCOSEFIPARTITION /tmp/FCOSEFIpart
sudo rsync -avh --ignore-existing /tmp/RPi4boot/boot/efi/ /tmp/FCOSEFIpart/
sudo umount /tmp/FCOSEFIpart
sync
```

Make sure your usb (`/dev/sda`) is GPT partitioned, `sudo fdisk /dev/sdg` -> `g` -> `write` -> `exit`