#!/bin/bash

set -e

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"

source "$INCLUDESLOC"/colordefines.sh

# https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671
# symlink settings
cbecho "Symlinking settings (lcdfilter-default, sub-pixel-rgb, hinting-slight)"
sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d

cbecho "Symlinking done"; echo # newline
cbecho "Installing font packages"
# install fonts-meta-extened-lt + some more fonts from the aur -- note: manually install win 7 / 8 /10 fonts if win 7 / 8 / 10 install to link against is available, remove ttf-ms-fonts and ttf-vista-fonts if you do
yay -S --needed fonts-meta-extended-lt ttf-hack

# install win fonts seperately, so if you have win-7/8/10 fonts installed you can cancel without loosing the rest
#echo # newline
#echo -e "${GB}Cancel this if you have win7/8/10 fonts installed ${RESET}"
#yay -S --needed ttf-ms-fonts ttf-vista-fonts ttf-tahoma

cbecho "Font's installed"

cbecho "Linking /etc/fonts config"

sudo ln -sf /etc/fonts/conf.avail/30-infinality-aliases.conf /etc/fonts/conf.d

echo # newline
cbecho "Updating Font Cache"

# probably not needed
fc-cache -r

sudo fc-cache -r

sudo gdk-pixbuf-query-loaders --update-cache

cbecho "Font-cache updated"; echo # newline
cbecho "Removing Orphan packages"

if pacman -Qtdq &>/dev/null; then
	sudo pacman -Rns $(pacman -Qtdq) # remove orphans we created (cabextract and font-forge)
else
    gecho "No Orphans"
fi

# update jre to use patched fonts
echo # newline
cbecho "Patching java to use better fonts"
echo "# Do not change this unless you want to completely by-pass Arch Linux' way of handling Java versions and vendors. Instead, please use script 'archlinux-java'
export PATH=\${PATH}:/usr/lib/jvm/default/bin

# https://wiki.archlinux.org/index.php/java#Better_font_rendering
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'" | sudo tee /etc/profile.d/jre.sh 1> /dev/null
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
