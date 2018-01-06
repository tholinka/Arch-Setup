#!/bin/bash

# so many deps
function get_deps()
{
    ## optional dependencies
    git="tk perl-libwww perl-term-readkey python2 subversion"
    nemo="ffmpegthumbnailer"
    # widevine (netflix support) is in aur
    chromium="pepper-flash"
    plasma="packagekit-qt5 gtk2 kross plasma-nm"
    kdeApps="p7zip qt5-imageformats cdrtools vorbis-tools ffmpeg libvncserver opus"
    # pretty sure we have this after xorg, but (shrug)
    ssh="xorg-xauth x11-ssh-askpass"
    # specifically not doing: dnsmasq (unbound handles it), openresolv (unbound handles it)
    networkManager="bluez dhclient modemmanager ppp"
    unbound="expat"

    together="$git $nemo $chromium $plasma $kdeApps $ssh $networkManager $unbound"
    eval "$1='$together'"
}