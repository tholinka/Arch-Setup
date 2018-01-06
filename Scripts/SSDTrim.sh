#!/bin/bash

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"

source "$INCLUDESLOC/colordefines.sh"

# enable periodic trim timers, it's part of util-linux so it should be installed anyway

if ! pacman -Q util-linux &>/dev/null; then
    sudo pacman -S --needed --noconfirm util-linux
fi

cecho "Enabling & starting fstrim.timer"
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

cecho "Running fstrim.service, as it won't run until the timer activates in ~a week otherwise"
sudo systemctl start fstrim.service

# maybe ? https://askubuntu.com/a/377363 seems like a good idea, but "most" people don't need to
if pacman -Q lvm2 &>/dev/null; then
    cbecho "Patching lvm to issue discards"
    echo "--- lvm.conf.orig	2018-01-06 03:15:51.789501235 -0700
+++ lvm.conf	2018-01-06 03:16:03.142748568 -0700
@@ -298,7 +298,7 @@
 	# benefit from discards, but SSDs and thinly provisioned LUNs
 	# generally do. If enabled, discards will only be issued if both the
 	# storage and kernel provide support.
-	issue_discards = 0
+	issue_discards = 1

 	# Configuration option devices/allow_changes_with_duplicate_pvs.
 	# Allow VG modification while a PV appears on multiple devices." | sudo patch -p0 -N /etc/lvm/lvm.conf
fi

gbecho "On supported filesystems (ext4, btrfs, jfs, xfs, f2fs, vfat) (NOT ntfs or ext3, see arch wiki for more) you may want to add \"discard\" to the options section of your /etc/fstab entries"
