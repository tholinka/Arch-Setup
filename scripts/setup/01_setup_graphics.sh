#!/bin/bash

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/../includes"
source "$INCLUDESLOC/colordefines.sh"

cbecho "Finishing graphics card setup"

# nvidia
if pacman -Q nvidia-settings &>/dev/null; then
	cecho "Setting nvidia-xconfig (with cool-bits of 12, enable fan and overclocking)"
	sudo nvidia-xconfig --cool-bits=12
fi

# intel
if pacman -Q xf86-video-intel &> /dev/null; then
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

# virtualbox
if pacman -Q virtualbox-guest-utils &>/dev/null; then
	# enable systemd service
	sudo systemctl enable vboxservice.service
fi
