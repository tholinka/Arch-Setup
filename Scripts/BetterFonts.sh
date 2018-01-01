#!/bin/sh

source includes/colordefines.sh

# https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671
# symlink settings
echo -e "${CB}Symlinking settings (lcdfilter-default, sub-pixel-rgb, hinting-slight) ${RESET}"
sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d

echo -e "${CB}Symlinking done ${RESET}"; echo # newline
echo -e "${CB}Installing font packages ${RESET}"
# install fonts-meta-extened-lt + some more fonts from the aur -- note: manually install win 7 / 8 /10 fonts if win 7 / 8 / 10 install to link against is available, remove ttf-ms-fonts and ttf-vista-fonts if you do
trizen -S --needed --noedit fonts-meta-extended-lt ttf-hack

# install win fonts seperately, so if you have win-7/8/10 fonts installed you can cancel without loosing the rest
echo # newline
echo -e "${GB}Cancel this if you have win7/8/10 fonts installed ${RESET}"
trizen -S --needed --noedit ttf-ms-fonts ttf-vista-fonts ttf-tahoma

echo -e "${CB}Font's installed ${RESET}"; echo # newline
echo -e "${CB}Updating Font Cache ${RESET}"

# probably not needed
fc-cache -r

echo -e "${CB}Font-cache updated ${RESET}"; echo # newline
echo -e "${CB}Removing Orphan packages ${RESET}"

if pacman -Qtdq &>/dev/null; then
	sudo pacman -Rns $(pacman -Qtdq) # remove orphans we created (cabextract and font-forge)
else
    echo -e "${GREEN}No Orphans ${RESET}"
fi

# update jre to use patched fonts
echo # newline
echo -e "${CB}Patching java to use better fonts ${RESET}"
echo "# Do not change this unless you want to completely by-pass Arch Linux' way of handling Java versions and vendors. Instead, please use script 'archlinux-java'
export PATH=\${PATH}:/usr/lib/jvm/default/bin

# https://wiki.archlinux.org/index.php/java#Better_font_rendering
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'" | sudo tee /etc/profile.d/jre.sh 1> /dev/null
echo # newline

# update wine to use patched fonts, assuming
echo -e "${CB}Linking wine against new fonts ${RESET}"
if [ -z ${WINEPREFIX+x} ]; then
    echo -e "${GREEN}run this command with 'env WINEPREFIX=[your prefix]' before the command to use something other than $HOME/.wine as your wine prefix ${RESET}"
    prefix="$HOME/.wine"
else
    prefix="${WINEPREFIX}"
fi

cd ${prefix}/drive_c/windows/Fonts && for i in /usr/share/fonts/**/*.{ttf,otf}; do ln -sf "$i" ; done

echo # newline
echo -e "${GB}Log out / in for the new fonts to register all the way, run 'wineserver -kw' to restart the wine server ${RESET}"
echo -e "${GB}Don't forget to change your font Super + N -> gear -> font ${RESET}"
