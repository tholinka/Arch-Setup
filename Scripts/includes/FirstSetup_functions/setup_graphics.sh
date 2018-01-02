#!/bin/sh

function setup_graphics()
{
    cbecho "Finishing graphics card setup"

    # nvidia
    if pacman -Q nvidia-dkms &>/dev/null; then
        cecho "Setting nvidia-xconfig (with cool-bits of 12, enable fan and overclocking)"
        sudo nvidia-xconfig --cool-bits=12
    fi
}