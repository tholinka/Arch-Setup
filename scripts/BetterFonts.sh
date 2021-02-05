#!/bin/bash

# you probably want 'noto-fonts ttf-hack powerline-fonts'

set -e

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"

source "$INCLUDESLOC"/colordefines.sh

# https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671
# symlink settings
cbecho "Symlinking settings (lcdfilter-default, sub-pixel-rgb, hinting-slight)"
sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
sudo ln -sf /etc/fonts/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d/

cbecho "Symlinking done"; echo # newline

echo # newline
cbecho "Updating Font Cache"

# probably not needed
fc-cache -r || true
sudo fc-cache -r || true

sudo gdk-pixbuf-query-loaders --update-cache || true

cbecho "Font-cache updated"; echo # newline

# update jre to use patched fonts
echo # newline
cbecho "Patching java to use better fonts"
sudo tee /etc/profile.d/jre.sh 1> /dev/null << EOF
# Do not change this unless you want to completely by-pass Arch Linux' way of handling Java versions and vendors. Instead, please use script 'archlinux-java'
export PATH="\${PATH}:/usr/lib/jvm/default/bin"

# https://wiki.archlinux.org/index.php/java#Better_font_rendering
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
EOF
echo # newline

# update wine to use patched fonts, assuming
cbecho "Linking wine against new fonts"
if [ -z ${WINEPREFIX+x} ]; then
    gecho "run this command with 'env WINEPREFIX=[your prefix]' before the command to use something other than $HOME/.wine as your wine prefix"
    prefix="$HOME/.wine"
else
    prefix="${WINEPREFIX}"
fi
if [ -d "${prefix}" ]; then
	cd "${prefix}"/drive_c/windows/Fonts && for i in /usr/share/fonts/**/*.{ttf,otf}; do ln -sf "$i" ; done
	gbecho "run 'wineserver -kw' to restart the wine server"
fi

echo # newline
gbecho "Relog for the new fonts to register"
