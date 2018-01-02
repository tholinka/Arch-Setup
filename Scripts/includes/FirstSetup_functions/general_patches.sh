#!/bin/sh

# "general" patches, aka one or two off patches for random things (e.g. unbound is a seperate file because there are many patches for one "thing"
general_patches()
{
    cbecho "Applying patches to config files"
    ## lightdm
    cecho "Applying patch to lightdm.conf"
    echo "--- lightdm.conf.orig  2017-12-30 23:35:34.621600509 -0700
+++ lightdm.conf        2017-12-30 23:28:44.163553765 -0700
@@ -108 +108 @@
-#greeter-session=example-gtk-gnome
+greeter-session=lightdm-webkit2-greeter" | sudo patch -p0 -N /etc/lightdm/lightdm.conf

    ## pacman
    cecho "Patching pacman.conf"
    echo "@@ -34 +34 @@
-#Color
+Color
@@ -93,2 +93,2 @@
-#[multilib]
-#Include = /etc/pacman.d/mirrorlist
+[multilib]
+Include = /etc/pacman.d/mirrorlist" | sudo patch -p0 -N /etc/pacman.conf

    # makepkg (part of pacman)
    cecho "Patching makepkg.conf"
    echo "@@ -40,2 +40,2 @@
-CFLAGS=\"-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong -fno-plt\"
-CXXFLAGS=\"-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong -fno-plt\"
+CFLAGS=\"-march=native -mtune=native -O3 -pipe -fstack-protector-strong -fno-plt\"
+CXXFLAGS=\"-march=native -mtune=native -O3 -pipe -fstack-protector-strong -fno-plt\"
@@ -44 +44 @@
-#MAKEFLAGS=\"-j2\"
+MAKEFLAGS=\"-j$(nproc)\"
@@ -62 +62 @@
-BUILDENV=(\!distcc color \!ccache check \!sign)
+BUILDENV=(fakeroot \!distcc color ccache check \!sign)" | sudo patch -p0 -N /etc/makepkg.conf

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
    cecho "Patching NetworkManager to use ipv6 privacy extensions"
    echo "@@ -6,3 +6,18 @@

 #[ifupdown]
 #managed=false
+
+# https://wiki.archlinux.org/index.php/IPv6#NetworkManager
+[connection]
+ipv6.ip6-privacy=2
+
+# https://unix.stackexchange.com/a/90061
+[ipv4]
+method=auto
+dns=127.0.0.1;
+ignore-auto-dns=true
+
+[ipv6]
+method=auto
+dns=::1;
+ignore-auto-dns=true" | sudo patch -p0 -N /etc/NetworkManager/NetworkManager.conf
}