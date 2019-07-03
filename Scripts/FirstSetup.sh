#!/bin/bash

#set -x
set -e

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

# base packages we always want
PACKAGES="base-devel pacman-contrib zsh git neovim ufw cpupower openssh networkmanager ccache colorgcc irqbalance curl"

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

# install yay, we need it for the next step
setup_aur

echo;
cecho "Installing systemd-boot pacman hook (from aur, using yay)"
yay -S --noconfirm --needed systemd-boot-pacman-hook
echo;

echo;
cbecho "Package Installation done"
echo;

# remove extra / uneeded packages
remove_pkgs KERNEL_SET
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

# minor performance boost
disable_hardware_watchdog
echo;

# ipv6 privacy stuff
setup_ipv6

# enable systemctl services (e.g. NetworkManager, dnsmasq, sddm)
setup_systemctl
echo;

# set up pacman hooks
setup_pacman_hooks
echo;

# switch to zsh / set up root's zsh
setup_zsh
echo;

cbecho "Running pacman update (pacman -Syu) to grab multilib and update system"
sudo pacman -Syu || true
