#!/bin/bash

#set -x

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"
FIRSTSETUPINCLUDES="$INCLUDESLOC/FirstSetup_functions"

source "$INCLUDESLOC/colordefines.sh"

# set up prompt colors / questions for __get and various other uses
C="$GREEN"
P="? [yN]: "

# source sub-functions
for i in "$FIRSTSETUPINCLUDES"/*.sh; do
    source "$i"
done

cbecho "Updating pacman (pacman -Syu) to make sure package lists are up to date"
sudo pacman -Syu

echo;

PACKAGES="xorg zsh git nemo chromium guake vim gufw plasma kde-applications cpupower openssh networkmanager ccache fakeroot colorgcc irqbalance procps-ng unbound curl postfix"

# all the deps
PACKAGESdeps=""
get_deps PACKAGESdeps


cbecho "Enter "y" if the case applies to you"

# ask if using wifi
GENERAL=""
get_general GENERAL
echo;

# ask which kernel to use
KERNEL=""
get_kernel KERNEL && KERNEL_SET="y"
echo;

# ask which video drivers to install
VIDEO_CARD=""
NEEDS_KERNEL_HEADERS=""
VIDEO_CARD_IS=""
get_graphics VIDEO_CARD NEEDS_KERNEL_HEADERS VIDEO_CARD_IS
echo;

# only include headers if needed
if [ "$NEEDS_KERNEL_HEADERS" == "y" ]; then
    KERNEL="${KERNEL} ${KERNEL}-headers"
fi

cbecho "Installing packages"
sudo pacman -S --needed --noconfirm $PACKAGES $GENERAL $KERNEL $VIDEO_CARD

echo;

cecho "Installing optional deps"
sudo pacman -S --needed --noconfirm --asdeps $PACKAGESdeps

echo;

# install trizen, we need it for the next step
setup_aur

echo;
cecho "Installing lightdm greeter (from aur, using trizen)"
trizen -S --noconfirm --needed lightdm-webkit2-theme-material2

echo;
cbecho "Package Installation done"
echo;

# remove extra / uneeded packages
remove_pkgs KERNEL_SET
echo;

# setup unbound to act as a local dns server to cache requests
setup_unbound
echo;

# various config patches
general_patches
echo;

# setup open_vm_tools (function checks if they are installed first)
setup_vm

# link proc/version to arch-release, primarly for vmware
sudo ln -sf /proc/version /etc/arch-release

# finish setting up graphics drivers
setup_graphics "$VIDEO_CARD_IS"
echo;

# set up wifi regdom, echo newline if it set anything
setup_wifi && echo;

# set up ufw
setup_firewall
echo;

# network perf speed
setup_sysctl
echo;

# enable systemctl services (e.g. NetworkManager, dnsmasq, lightdm)
setup_systemctl
echo;

# set up pacman hooks
setup_pacman_hooks
echo;

# switch to zsh / set up root's zsh
setup_zsh
echo;

cbecho "Running pacman update (pacman -Syu) to grab multilib and update system"
sudo pacman -Syu
