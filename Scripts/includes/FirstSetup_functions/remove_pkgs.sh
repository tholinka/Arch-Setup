#!/bin/sh

function remove_pkgs()
{
    cbecho "Removing uneeded packages"

    if pacman -Q netctl &>/dev/null; then
        REMOVE_PACKAGES="$REMOVE_PACKAGES netctl"
    fi

    if __get "Remove konqueror, dolphin, sddm, and kate"; then
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