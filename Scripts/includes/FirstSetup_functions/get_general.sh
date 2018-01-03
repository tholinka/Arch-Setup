#!/bin/bash

# pass in a variable to set with package names
function get_general()
{
    if __get "WiFi"; then
        _GENERAL_PACKAGES="$packages crda"
    fi

    if __get "zswap (adds ~25% of ram as compressed swap that reduces i/o use of normal swap)"; then
        _GENERAL_PACKAGES="$packages systemd-swap"
    fi

    if [ -z ${_GENERAL_PACKAGES+x} ]; then
        eval "$1='$_GENERAL_PACKAGES'"
        return 0
    fi


    return 1
}