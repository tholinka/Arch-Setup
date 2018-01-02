#!/bin/sh

# pass in a variable to get video packages, and other to get if that requires kernel headers
function get_graphics()
{
    cecho "Which video card do you have? [Nvidia, AMD, Intel, VMware/Virtualbox]"

    nvidia="nvidia-dkms nvidia-utils libva-vdpau-driver xorg-server-devel nvidia-settigns opencl-nvidia" # closed source drivers
    amd="xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau" # open source drivers
    intel="xf86-video-intel mesa libva-intel-driver libvdpau-va-gl" # open source drivers
    vm="open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa-libgl libva-mesa-driver mesa-vdpau virtualbox-guest-dkms virtualbox-guest-utils gtkmm libxtst" # open source drivers

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

    if __get "VirtualBox / VMware"; then
        eval "$1='$vm'"
        eval "$2='y'"
        eval "$3='vm'"
        return 0
    fi

    eval "$1='$norm'"

    return 1
}