#!/bin/bash

SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"

source "$INCLUDESLOC/colordefines.sh"

cbecho "Installing Steam"

if pacman -Q mesa &>/dev/null; then
    cecho "Mesa is installed, installing lib32-mesa (intel/amd)"
    INTEL="lib32-mesa"
fi

if pacman -Q nvidia-utils &>/dev/null; then
    cecho "nvidia-utils installed, installing lib32-nvidia-utils (nvidia)"
    NVIDIA="lib32-nvidia-utils"
fi

PACKAGES="steam"
sudo pacman -S --needed --noconfirm \
$PACKAGES \
$INTEL \
$NVIDIA


echo;
gbecho "Fonts will look bad / not be there if you haven't installed the better fonts"
