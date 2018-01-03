#!/bin/bash

function setup_graphics()
{
    cbecho "Finishing graphics card setup"

    # nvidia
    if [ "$1" == nvidia ]; then
        cecho "Setting nvidia-xconfig (with cool-bits of 12, enable fan and overclocking)"
        sudo nvidia-xconfig --cool-bits=12
    fi

    # intel
    if [ "$1 == intel" ]; then
        # https://wiki.archlinux.org/index.php/intel_graphics#Module-based_Powersaving_Options this does taint the kernel
        # https://wiki.archlinux.org/index.php/intel_graphics#Enable_GuC_.2F_HuC_firmware_loading for the enable_guc_loading portion
        cecho "Enabling intel powersaving"
        echo "#https://wiki.archlinux.org/index.php/intel_graphics#Module-based_Powersaving_Options
options i915 enable_rc6=1 enable_fbc=1 semaphores=1 enable_guc_loading=1" | sudo tee /etc/modprobe.d/i915.conf 1>/dev/null

        # https://wiki.archlinux.org/index.php/intel_graphics#Xorg_configuration
        cecho "Adding intel to xorg.conf.d"
        echo "Section \"Device\"
  Identifier  \"Intel Graphics\"
  Driver      \"intel\"
EndSection" | sudo tee /etc/X11/xorg.conf.d/20-intel.conf 1>/dev/null
    fi
}
