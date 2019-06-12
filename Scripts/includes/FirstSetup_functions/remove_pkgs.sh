#!/bin/bash

function remove_pkgs()
{
    cbecho "Removing uneeded packages"

    REMOVE_PACKAGES=""

    if pacman -Q netctl &>/dev/null; then
        REMOVE_PACKAGES="$REMOVE_PACKAGES netctl"
    fi
    if pacman -Q dhcpcd &>/dev/null; then
        REMOVE_PACKAGES="$REMOVE_PACKAGES dhcpcd"
    fi

    if [ ! -z ${0+x} ]; then
        if __get "Remove normal linux kernel (aka linux) $BOLD (DON'T FORGET TO CHANGE /boot ENTRY!)"; then
            if pacman -Q linux &>/dev/null; then
                REMOVE_PACKAGES="$REMOVE_PACKAGES linux"
            fi
            if pacman -Q linux-headers &>/dev/null; then
                REMOVE_PACKAGES="$REMOVE_PACKAGES linux-headers"
            fi
        fi
    fi

    sudo pacman -Rns --noconfirm $REMOVE_PACKAGES
}
