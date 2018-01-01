#!/bin/sh
source includes/colordefines.sh

echo -e "$CYAN Updating pacman (pacman -Syu) to make sure package lists are up to day $RESET"
sudo pacman -Syu

PACKAGES="xorg zsh git nemo chromium guake vim gufw plasma-desktop kde-applications cpupower openssh networkmanager ccache fakeroot colorgcc syslog-ng"
PACKAGESdeps="dhclient blueman libproxy modem-manager-gui packagekit"
echo -e "$CB Enter "y" if the case applies to you $RESET"

C="$GREEN"
P="? [yN]: "


echo -en "$C WiFi $RESET"
read -p "$P" yn

case $yn in
    [Yy]* )
        WIFI="crda"
        ;;
esac

KERNEL="linux"

echo -e "$CB Choose Kernel [Linux-Zen Linux-hardened] $RESET"

echo -en "$C Linux-Zen $RESET"
read -p "$P" yn
case $yn in
    [Yy]* )
        KERNEL="${KERNEL}-zen"
        KERNEL_SET=zen
        ;;
esac

if [ -z ${KERNEL_SET+x} ]; then
    echo -en "$C Linux-Hardened $RESET"
    read -p "$P" yn
    case $yn in
        [Yy]* )
            KERNEL="${KERNEL}-hardened"
            KERNEL_SET=hardened
            ;;
    esac
fi

echo -e "$CB Which video card [Nvidia, AMD, Intel, VMware/Virtualbox]$RESET"

echo -en "$C Nvidia $RESET"
read -p "$P" yn

case $yn in
    [Yy]* )
        VIDEO_CARD="nvidia-dkms nvidia-utils libva-vdpau-driver xorg-server-devel nvidia-settigns opencl-nvidia"
        VIDEO_CARD_SET="nvidia"
        NEEDS_KERNEL_HEADERS=true
        ;;
esac

if [ -z ${VIDEO_CARD_SET+x} ]; then
    echo -en "$C AMD $RESET"
    read -p "$P" yn

    case $yn in
        [Yy]* )
            VIDEO_CARD="xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau"
            VIDEO_CARD_SET="amd"
            # only needs headers for catalyst-dkms from the aur
            ;;
    esac
fi

if [ -z ${VIDEO_CARD_SET+x} ]; then
    echo -en "$C Intel $RESET"
    read -p "$P" yn

    case $yn in
        [Yy]* )
            VIDEO_CARD="xf86-video-intel mesa libva-intel-driver libvdpau-va-gl"
            VIDEO_CARD_SET="intel"
            # should never need headers
            ;;
    esac
fi

if [ -z ${VIDEO_CARD_SET+x} ]; then
    echo -en "$C VirtualBox $RESET"
    read -p "$P" yn
    case $yn in
        [Yy]* )
            VIDEO_CARD="open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa-libgl libva-mesa-driver mesa-vdpau virtualbox-guest-dkms virtualbox-guest-utils gtkmm libxtst"
            VIDEO_CARD_SET="virtualbox"
            NEEDS_KERNEL_HEADERS=true
            ;;
    esac
fi

# only include headers if needed
if [ ! -z ${NEEDS_KERNEL_HEADERS+x} ]; then
    KERNEL="${KERNEL} ${KERNEL}-headers"
fi

sudo pacman -S --needed --noconfirm $PACKAGES \
$KERNEL \
$WIFI \
$VIDEO_CARD

echo -e "$CYAN Installing optional deps $RESET"
sudo pacman -S --needed --noconfirm $PACKAGESdeps

echo -e "$CYAN Installation done $RESET"

if pacman -Q netctl &>/dev/null; then
    REMOVE_PACKAGES="$REMOVE_PACKAGES netctl"
fi

echo -en "$C Remove konqueror, dolphin, sddm, and kate $RESET"
read -p "$P" yn
case $yn in
    [Yy]* )
        if pacman -Q konqueror &> /dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES konqueror"
        fi
        if pacman -Q dolphin &> /dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES dolphin"
        fi
        if pacman -Q dolphin-plugins &>/dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES dolphin-plugins"
        fi
        if pacman -Q sdd-kcm &>/dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES sddm-kcm"
        fi
        if pacman -Q sddm &>/dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES sddm"
        fi
        if pacman -Q kate &> /dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES kate"
        fi
esac

if [ ! -z ${KERNEL_SET+x} ]; then
    echo -en "$C Remove normal linux kernel (aka linux) $BOLD (DON'T FORGET TO CHANGE /boot ENTRY!) $RESET"
    read -p "$P" yn

    case $yn in
        [Yy]* )
            if pacman -Q linux &>/dev/null; then
                REMOVE_PACKAGES="$REMOVE_PACKAGES linux"
            fi
            if pacman -Q linux-headers &>/dev/null; then
                REMOVE_PACKAGES="$REMOVE_PACKAGES linux-headers"
            fi
    esac
fi

sudo pacman -Rns --noconfirm $REMOVE_PACKAGES

echo -e "$CYAN Installing lightdm-webkit2-theme-material2 $RESET"
trizen -S --noprompt lightdm-webkit2-theme-material2

echo -e "$CYAN Applying patch to lightdm.conf $RESET"
echo "--- lightdm.conf.orig  2017-12-30 23:35:34.621600509 -0700
+++ lightdm.conf        2017-12-30 23:28:44.163553765 -0700
@@ -108 +108 @@
-#greeter-session=example-gtk-gnome
+greeter-session=lightdm-webkit2-greeter" | sudo patch -p0 -N /etc/lightdm/lightdm.conf


# configure packages
echo -e "$CYAN Enabling lightdm $RESET"
sudo systemctl enable lightdm
echo -e "$CYAN Enabling NetworkManager (please manually disable wifi menu profiles through systemctl disable netctl@<wifi-menu-profile>) $RESET"
sudo systemctl enable NetworkManager

if pacman -Q open-vm-tools &>/dev/null;  then
    echo -e "$CYAN Enabling vmware vmblock fuse $RESET"
    sudo systemctl enable vmware-vmblock-fuse.service

    # also enable vmware (open-vm-tools) suid wrapper
    echo -e "$CYAN Running user-suid wrapper $RESET"
    /usr/bin/vmware-user-suid-wrapper

    # set desktop file to autostart suid wrapper
    echo "[Desktop Entry]
Encoding=UTF-8
Name=VMware User SUID Wrapper
Comment=Enable VMware Communication (auto window resize, copy/paste, etc.) from within guest
TryExec=vmware-user-suid-wrapper
Exec=vmware-user-suid-wrapper
Icon=vmware-user-suid-wrapper
Type=Application
Categories=System;Utility;
StartupNotify=false
X-Desktop-File-Install-Version=0.22" > ~/.config/autostart/vmware-user-suid-wrapper.desktop
fi

# link proc/version to arch-release, primarly for vmware
sudo ln -sf /proc/version /etc/arch-release

if pacman -Q nvidia-dkms &>/dev/null; then
    echo -e "$CYAN Setting nvidia-xconfig (with cool-bits of 12, enable fan and overclocking) $RESET"
    sudo nvidia-xconfig --cool-bits=12
fi

if [ ! -z ${WIFI+x} ]; then
    echo -en "$C What's your country? (2 letter code, e.g. United States is US, Great Briten is GB, etc.): $RESET"
    read COUNTRY
    echo -e "$CYAN setting /etc/conf.d/wireless-regdom to $COUNTRY $RESET"
    echo "WIRELESS_REGDOM=\"$COUNTRY\"" | sudo tee /etc/conf.d/wireless-regdom > /dev/null
fi

echo -e "$CYAN Setting CPUPOWER governer to Performance $RESET"

echo "governer='performance'" | sudo tee /etc/default/cpupower > /dev/null

echo -e "$CYAN Patching pacman.conf $RESET"
echo "@@ -34 +34 @@
-#Color
+Color
@@ -93,2 +93,2 @@
-#[multilib]
-#Include = /etc/pacman.d/mirrorlist
+[multilib]
+Include = /etc/pacman.d/mirrorlist" | sudo patch -p0 -N /etc/pacman.conf

echo -e "$CYAN Patching makepkg.conf $RESET"
echo "@@ -40,2 +40,2 @@
-CFLAGS=\"-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong -fno-plt\"
-CXXFLAGS=\"-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong -fno-plt\"
+CFLAGS=\"-march=native -mtune=native -O3 -pipe -fstack-protector-strong -fno-plt\"
+CXXFLAGS=\"-march=native -mtune=native -O3 -pipe -fstack-protector-strong -fno-plt\"
@@ -44 +44 @@
-#MAKEFLAGS=\"-j2\"
+MAKEFLAGS=\"-j$(nproc)\"
@@ -62 +62 @@
-BUILDENV=(\!distcc color \!ccache check \!sign)
+BUILDENV=(fakeroot \!distcc color ccache check \!sign)" | sudo patch -p0 -N /etc/makepkg.conf

echo -e "$CYAN Patching colorgcc to use ccache $RESET"
echo "@@ -39,5 +39,8 @@
-# Uncomment this if you want set up default path to gcc
-#g++: /usr/bin/g++
-#gcc: /usr/bin/gcc
-#c++: /usr/bin/c++
-#cc:  /usr/bin/cc
+# Use ccache, from https://wiki.archlinux.org/index.php/ccache#Enable_with_colorgcc
+g++: /usr/lib/ccache/bin/g++
+gcc: /usr/lib/ccache/bin/gcc
+c++: /usr/lib/ccache/bin/g++
+cc: /usr/lib/ccache/bin/cc
+g77:/usr/bin/g77
+f77:/usr/bin/g77
+gcj:/usr/bin/gcj" | sudo patch -p0 -N /etc/colorgcc/colorgccrc

echo -e "$CYAN Setting up syslog-ng $RESET"
sudo systemctl enable syslog-ng
sudo systemctl start systlog-ng
echo -e "$CYAN Changing shell to zsh $RESET"
chsh -s /usr/bin/zsh
# change roots as well
sudo chsh -s /usr/bin/zsh

echo -e "$CYAN Setting root to use user zsh config $RESET"
echo "export ZSH_CONFIG=\"$HOME/.zsh-config\"
echo -e \"\e[36mHit \\\"y\\\" to accept the warning\e[39m\"
source $HOME/.zsh-config/zshrc.zshrc" | sudo tee /root/.zshrc >/dev/null
echo "source $HOME/.zprofile" | sudo tee /root/.zprofile >/dev/null

echo -e "$CYAN Setting pacman hooks to clean paccache on upgrade and remove $RESET"

# need /etc/pacman.d/hooks
if [ ! -d /etc/pacman.d/hooks ]; then
    sudo mkdir /etc/pacman.d/hooks
fi

## from https://www.reddit.com/r/archlinux/comments/7k4ke8/reminder_run_paccache_r_everynow_and_then/drbkqby/
# cleans all but the two most recent versions of package on upgade
echo "[Trigger]
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache (upgrade, removing all but two most recent versions)...
When = PostTransaction
Exec = /usr/bin/paccache -rk2" | sudo tee /etc/pacman.d/hooks/paccache-upgrade.hook > /dev/null

# clears all cached versions of a package on removal
echo "[Trigger]
Operation = Remove
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache (remove, removing all versions)...
When = PostTransaction
Exec = /usr/bin/paccache -ruk0" | sudo tee /etc/pacman.d/hooks/paccache-remove.hook > /dev/null

echo -e "$CYAN Running pacman update (pacman -Syu) to grab multilib and update system $RESET"
sudo pacman -Syu