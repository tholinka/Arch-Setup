#!/bin/bash

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"
FIRSTSETUPINCLUDES="$INCLUDESLOC/FirstSetup_functions"

source "$INCLUDESLOC"/colordefines.sh
source "$FIRSTSETUPINCLUDES"/__get.sh

cecho "Installing TLP"

sudo pacman -S --needed --noconfirm tlp
# only thinkpads need these, but they dont really /hurt/
cecho "Installing optional depends"
optdeps="x86_energy_perf_policy smartmontools lsb-release ethtool"

if __get "Thinkpad?"; then
    if __get "Normal linux kernel? (dkms vs prebuilt mods; no if unsure, will result in less tlp functionality)"; then
        cecho "Installing normal acpi_call and tp_smapi"
        optdeps="$optdeps acpi_call tp_smapi"
    else
        cecho "Installing acpi_call-dkms, there is no tp_smapi dkms version, this will result in less tlp funcationality"
        optdeps="$optdeps acpi_call-dkms"
    fi
fi

sudo pacman -S --asdeps --needed --noconfirm $optdeps

if __get "Intel CPU?"; then
    cecho "Patching tlp config"
    gecho "You may want to change DISK_DEVICES, it is setup for a ssd only system, replace it with the drives that are disks (e.g. if /dev/sda is a disk, replace it with sda, etc"

    echo "--- tlp.original	2018-05-24 21:11:15.497318272 -0600
+++ tlp	2018-05-24 21:22:17.872770756 -0600
@@ -44,2 +44,2 @@
-#CPU_SCALING_GOVERNOR_ON_AC=powersave
-#CPU_SCALING_GOVERNOR_ON_BAT=powersave
+CPU_SCALING_GOVERNOR_ON_AC=performance
+CPU_SCALING_GOVERNOR_ON_BAT=powersave
@@ -66,4 +66,4 @@
-#CPU_MIN_PERF_ON_AC=0
-#CPU_MAX_PERF_ON_AC=100
-#CPU_MIN_PERF_ON_BAT=0
-#CPU_MAX_PERF_ON_BAT=30
+CPU_MIN_PERF_ON_AC=0
+CPU_MAX_PERF_ON_AC=100
+CPU_MIN_PERF_ON_BAT=0
+CPU_MAX_PERF_ON_BAT=50
@@ -76,2 +76,2 @@
-#CPU_BOOST_ON_AC=1
-#CPU_BOOST_ON_BAT=0
+CPU_BOOST_ON_AC=1
+CPU_BOOST_ON_BAT=0
@@ -103 +103 @@
-DISK_DEVICES="sda sdb"
+DISK_DEVICES=""
@@ -214 +214 @@
-USB_BLACKLIST_BTUSB=0
+USB_BLACKLIST_BTUSB=1
@@ -218 +218 @@
-USB_BLACKLIST_PHONE=0
+USB_BLACKLIST_PHONE=1" | sudo patch -p0 -N /etc/default/tlp
else
    gbecho "NOT patching tlp config"
fi

gbecho "Edit /etc/default/tlp to liking"

cecho "Enabling + starting tlp in systemctl"
sudo systemctl enable tlp.service
sudo systemctl start tlp.service
