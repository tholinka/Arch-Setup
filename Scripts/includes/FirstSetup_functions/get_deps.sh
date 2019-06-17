#!/bin/bash

# so many deps
# anything that's installed but not actually needed will just be removed again when orphans are removed, so no big deal
function get_deps()
{
    ## optional dependencies
    git="tk perl-libwww perl-term-readkey subversion libsecret"

	firefox="libnotify pulseaudio hunspell-en_US hunspell"

    plasma="plasma-nm powerdevil kscreen"
    kdeApps="qt5-imageformats ffmpeg opus"
	# dolphin
	kdeApps="$kdeApps kde-cli-tools ffmpegthumbs kdegraphics-thumbnailers purpose"

    ssh="xorg-xauth x11-ssh-askpass"

    networkManager="bluez dhclient modemmanager ppp"
    # comment out if your using unbound
    networkManager="$networkManager dnsmasq"

    # uncomment out if your using unbound
    #unbound="expat"

	pacman="xdelta3"

	together="$git $firefox $plasma $kdeApps $ssh $networkManager $unbound $pacman"
	eval "$1='$together'"
}
