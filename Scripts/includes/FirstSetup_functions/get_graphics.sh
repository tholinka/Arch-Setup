#!/bin/bash

# pass in a variable to get video packages, and other to get if that requires kernel headers
function get_graphics()
{
    cecho "Which video card do you have? [Nvidia, AMD, Intel, VMware/Virtualbox]"

    nvidia="nvidia-dkms nvidia-utils libva-vdpau-driver xorg-server-devel nvidia-settings opencl-nvidia" # closed source drivers
    amd="xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau" # open source drivers
    intel="xf86-video-intel mesa libva-intel-driver libvdpau-va-gl" # open source drivers
    vmware="open-vm-tools xf86-video-vmware xf86-input-vmmouse" # open source drivers
    virtualbox="virtualbox-guest-dkms virtualbox-guest-utils"

    if __get "Nvidia"; then
        eval "$1='$nvidia'"
        eval "$2='y'"
        eval "$3='nvidia'"
        return 0
    fi

    if __get "AMD"; then
        eval "$1='$amd'"
        eval "$2='n'" # headers are needed for closed source catalyst driver on the aurs
        eval "$3='amd'"
        return 0
    fi

    if __get "Intel"; then
        eval "$1='$intel'"
        eval "$2='n'" # should never need headers
        eval "$3='intel'"
        return 0
    fi

    if __get "VMware"; then
        eval "$1='$vmware'"
        eval "$2='y'"
        eval "$3='vmware'"
        return 0
    fi

    if __get "VirtualBox"; then
        eval "$1='$virtualbox'"
        eval "$2='y'"
        eval "$3='virtualbox'"
        return 0
    fi

    eval "$1='$norm'"
}
