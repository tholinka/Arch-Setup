#!/bin/bash

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"
FIRSTSETUPINCLUDES="$INCLUDESLOC/FirstSetup_functions"

source "$INCLUDESLOC/colordefines.sh"

cbecho "Importing required gpg keys"

# libc++ and therefor discord requires an import of a keyi
libckey="11E521D646982372EB577A1F8F0871F202119294"
if ! gpg --list-keys | grep "$libckey" &>/dev/null; then
    cecho "Importing libc++ key"
    gpg --recv-keys "$libckey"
fi

# for spotify-stable
spotifykey="0DF731E45CE24F27EEEB1450EFDC8610341D9410"
if ! gpg --list-keys | grep "$spotifykey" &>/dev/null; then
    cecho "Importing spotify key, this seems to hang sometimes, give it a sec"
    gpg --keyserver hkps://pgp.mit.edu --recv-keys
fi

cbecho "Imports done, installing packages"

# install a bunch of packages
# in order of each line:
# spotify
# skype + other instant messages client
# replace vi with vim
# google drive sync
# discord + font for discord icons
# update systemd-boot on pacman update, install "missing" mkinitcpio firmware
# install chromium extras
# colorize make output (needs alias's in ~/.zsh-config/aliases.zshrc)

trizen -S --needed --noconfirm \
spotify-stable \
rambox \
vi-vim-symlink \
insync \
discord \
systemd-boot-pacman-hook wd719x-firmware aic94xx-firmware \
pepper-flash chromium-widevine \
colormake \
visual-studio-code-bin

# spotify deps
# discord deps
trizen -S --needed --noconfirm --asdeps \
ffmpeg0.10 libnotify zenity \
ttf-symbola

# add rambox autostart
cp "/usr/share/applications/rambox.desktop" "$HOME/.config/autostart"

# set electron.desktop to null and set to readonly, since rambox recreates it on every startup -.-
echo "" > "$HOME/.config/autostart/electron.desktop"
chmod 0444 "$HOME/.config/autostart/electron.desktop"
