#!/bin/bash

# "general" patches, aka one or two off patches for random things (e.g. unbound is a seperate file because there are many patches for one "thing"
general_patches()
{
    cbecho "Applying patches to config files"
    ## pacman
    cecho "Patching pacman.conf"
    echo "@@ -22 +22 @@
-#UseDelta    = 0.7
+UseDelta    = 0.7
@@ -34 +34 @@
-#Color
+Color
@@ -43 +43 @@
-#RemoteFileSigLevel = Required
+RemoteFileSigLevel = Required
@@ -93,2 +93,2 @@
-#[multilib]
-#Include = /etc/pacman.d/mirrorlist
+[multilib]
+Include = /etc/pacman.d/mirrorlist" | sudo patch -p0 -N /etc/pacman.conf

    # makepkg (part of pacman)
    cecho "Patching makepkg.conf"
    echo "@@ -40,2 +40,2 @@
-CFLAGS=\"-march=x86-64 -mtune=generic -O2 -pipe -fno-plt\"
-CXXFLAGS=\"-march=x86-64 -mtune=generic -O2 -pipe -fno-plt\"
+CFLAGS=\"-march=native -mtune=native -O2 -pipe -fno-plt\"
+CXXFLAGS=\"\$\{CFLAGS}\"
@@ -44 +44 @@
-#MAKEFLAGS=\"-j2\"
+MAKEFLAGS=\"-j\$\(nproc --all)\"
@@ -62 +62 @@
-BUILDENV=(\!distcc color \!ccache check \!sign)
+BUILDENV=(\!distcc color ccache check \!sign)" | sudo patch -p0 -N /etc/makepkg.conf

    cbecho "Set -ftree-vectorize in /etc/makepkg.conf CFLAGS, /most/ newer systems support this, but it may need to be removed"

    ## colorgcc -> ccache
    cecho "Patching colorgcc to use ccache"
    echo "@@ -39,5 +39,8 @@
-# Uncomment this if you want set up default path to gcc
-#g++: /usr/bin/g++
-#gcc: /usr/bin/gcc
-#c++: /usr/bin/c++
-#cc:  /usr/bin/cc
+# Use ccache, from https://wiki.archlinux.org/index.php/ccache#Enable_with_colorgcc
+g++: /usr/lib/ccache/bin/g++
+gcc: /usr/lib/ccache/bin/gcc
+c++: /usr/lib/ccache/bin/g++
+cc: /usr/lib/ccache/bin/cc
+g77:/usr/bin/g77
+f77:/usr/bin/g77
+gcj:/usr/bin/gcj" | sudo patch -p0 -N /etc/colorgcc/colorgccrc

    ## cpupower
    cecho "Patching cpupower to use performance governor"
    echo "@@ -3 +3 @@
-#governor='ondemand'
+governor='performance'" | sudo patch -p0 -N /etc/default/cpupower

    ## NetworkManager
    cecho "Setting up NetworkManager to use ipv6 privacy extensions & dnsmasq"

    # Tell dnsmasq to listen for ipv6 as well
    echo "listen-address=::1" | sudo tee /etc/NetworkManager/dnsmasq.d/ipv6_listen.conf &>/dev/null

    # use the patch below that's being echo'd to /dev/null if your using unbound
    echo "# Configuration file for NetworkManager.
# See \"man 5 NetworkManager.conf\" for details.

# https://wiki.archlinux.org/index.php/dnsmasq#NetworkManager
[main]
dns=dnsmasq

# https://wiki.archlinux.org/index.php/IPv6#NetworkManager
[connection]
ipv6.ip6-privacy=2" | sudo tee /etc/NetworkManager/NetworkManager.conf &>/dev/null

    # disabled, use instead of above if your using unbound
    echo "# Configuration file for NetworkManager.
# See \"man 5 NetworkManager.conf\" for details.

[main]
dns=dnsmasq

# https://wiki.archlinux.org/index.php/IPv6#NetworkManager
[connection]
ipv6.ip6-privacy=2

## disabled for dnsmasq
# https://unix.stackexchange.com/a/90061
#[ipv4]
#method=auto
#dns=127.0.0.1;
#ignore-auto-dns=true

#[ipv6]
#method=auto
#dns=::1;
#ignore-auto-dns=true" &> /dev/null # sudo tee /etc/NetworkManager/NetworkManager.conf &>/dev/null
}
