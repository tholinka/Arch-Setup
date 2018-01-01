#!/bin/sh
# enable periodic trim timers, it's part of util-linux so it should be installed anyway

source includes/colordefines.sh

echo -e "${GB}Enabling & starting fstrim.timer${RESET}"
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

echo -e "${GB}Running fstrim.service, as it won't run until the timer activates in ~a week otherwise${RESET}"
sudo systemctl start fstrim.service

echo -e "${CB}On supported filesystems (ext4, btrfs, jfs, xfs, f2fs, vfat) (NOT ntfs or ext3, see arch wiki for more) you may want to add "discard" to the options section of your /etc/fstab entries${RESET}"

echo -e "${CB}When using lvm, additionally edit \"issue_discards\" in \"/etc/lvm/lvm.conf\" from 0 to 1"
