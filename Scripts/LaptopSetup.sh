#!/bin/sh

source includes/colordefines.sh

if ! type trizen &>/dev/null; then
    echo -e "${GB}NO trizen, use \"AurSetup\" script first! ${RESET}"
    return;
fi

echo -e "${GB}Installing laptop-mode-tools + optional deps ${RESET}"

trizen -S --needed --noconfirm laptop-mode-tools
sudo pacman -S --asdeps --needed --noconfirm acpid bluez-utils hdparm sdparm ethtool wireless_tools xorg-xset python2-pyside

echo -e "${GB}Enabling laptop mode service in systemctl ${RESET}"
sudo systemctl enable laptop-mode.service

echo -e "${CB}Done, edit /etc/laptop-mode/laptop-mode.conf and /etc/laptop-mode/conf.d/* to liking ${RESET}"
echo -e "${GB}Patching /etc/laptop-mode/conf.d/auto-hibernate.conf to enable auto-hibernate at low battery ${RESET}"
echo "--- auto-hibernate.conf.orig	2017-12-31 02:11:40.268500485 -0700
+++ auto-hibernate.conf	2017-10-18 09:07:46.935191764 -0600
@@ -36 +36 @@
-ENABLE_AUTO_HIBERNATION=0
+ENABLE_AUTO_HIBERNATION=1" | sudo patch -p0 -N /etc/laptop-mode/conf.d/auto-hibernate.conf