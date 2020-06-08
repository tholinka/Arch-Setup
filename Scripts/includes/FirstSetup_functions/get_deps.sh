#!/bin/bash

# so many deps
# anything that's installed but not actually needed will just be removed again when orphans are removed, so no big deal
function get_deps()
{
    ## optional dependencies
    git="tk subversion"

	firefox="libnotify pulseaudio hunspell-en_US hunspell"

    plasma="plasma-nm powerdevil kscreen drkonqi"
    kdeApps="qt5-imageformats ffmpeg opus"
	kdeApps="$kdeApps kde-cli-tools ffmpegthumbs kdegraphics-thumbnailers purpose" # dolphin

    ssh="xorg-xauth x11-ssh-askpass"

    networkManager="bluez dhclient modemmanager ppp"
    # comment out if your using unbound
    networkManager="$networkManager dnsmasq"

    # uncomment out if your using unbound
    #unbound="expat"

	pacman="xdelta3"

	neovim="python-neovim xclip xsel"

	linux="crda"

	together="$git $firefox $plasma $kdeApps $ssh $networkManager $unbound $pacman $neovim $linux"
	eval "$1='$together'"
}
