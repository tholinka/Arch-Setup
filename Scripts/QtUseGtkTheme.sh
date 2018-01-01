#!/bin/sh

source includes/colordefines.sh

echo -e "${CB}This unifies the look of Qt and GTK+ apps, Qt should use the GKT+ theme${RESET}"

# install qt5-styleplugins if needed
if ! pacman -Q qt5-styleplugins &> /dev/null; then
    #newline
    echo
    echo -e "${CB}Need qt5-styleplugins to work...installing${RESET}"
    sudo pacman -S --needed --noconfirm qt5-styleplugins
    echo -e "${CB}Done${RESET}"
fi

#newline
echo

# set config
echo -e "${CB}Adding config setting to ~/.profile and ~/.xinitrc${RESET}"

exportSetting="export QT_QPA_PLATFORMTHEME=gtk2"
echo $exportSetting >> ~/.profile
echo $exportSetting >> ~/.xinitrc

echo -e "${CB}Done${RESET}"
echo #newline
echo -e "${CB}Setting trolltech config, WARNING: THIS WILL OVERWRITE ~/.config/Trolltech.conf !!${RESET}"

echo "
[Qt]
style=GTK+
" > ~/.config/Trolltech.conf

echo -e "${CB}Done${RESET}"
#newline
echo

echo -e "${GB}If this theme looks bad on Qt apps, install and run ${CB}gtk-theme-switch2${RESET}${GB} to switch the theme${RESET}"