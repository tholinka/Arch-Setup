#!/bin/bash

# so many deps
function get_deps()
{
    ## optional dependencies
    git="tk perl-libwww perl-term-readkey subversion libsecret"

    plasma="plasma-nm powerdevil kscreen"
    kdeApps="qt5-imageformats ffmpeg opus"
	# dolphin
	kdeApps="$kdeApps kde-cli-tools ffmpegthumbs kdegraphics-thumbnailers purpose"

    # pretty sure we have this after xorg, but (shrug)
    ssh="xorg-xauth x11-ssh-askpass"

    networkManager="bluez dhclient modemmanager ppp"
    # comment out if your using unbound
    networkManager="$networkManager dnsmasq"

    # uncomment out if your using unbound
    #unbound="expat"

    together="$git $nemo $chromium $plasma $kdeApps $ssh $networkManager $unbound"
    eval "$1='$together'"
}
