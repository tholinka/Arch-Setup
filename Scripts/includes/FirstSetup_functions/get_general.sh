#!/bin/bash

# pass in a variable to set with package names
function get_general()
{
	if __get "UI (Minimal KDE)"; then
		# add kde packages, very minimal
        _GENERAL_PACKAGES="$_GENERAL_PACKAGES plasma-desktop sddm-kcm plasma-pa kde-gtk-config breeze-gtk user-manager"
		if __get "Optional UI (dolphin, konsole, etc)"; then
            _GENERAL_PACKAGES="$_GENERAL_PACKAGES dolphin konsole kdeplasma-addons ark"
		fi
	fi

	if __get "General UI things (firefox, guake, gufw)"; then
		_GENERAL_PACKAGES="$_GENERAL_PACKAGES firefox guake"
    fi

    if __get "zswap (adds ~25% of ram as compressed swap that reduces i/o use of normal swap)"; then
        _GENERAL_PACKAGES="$_GENERAL_PACKAGES systemd-swap"
    fi

    eval "$1='$_GENERAL_PACKAGES'"
}
