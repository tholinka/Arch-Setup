#!/bin/sh


# libc++ and therefor discord requires an import of a key
gpg --recv-keys 11E521D646982372EB577A1F8F0871F202119294

# for spotify-stable
gpg --keyserver hkps://pgp.mit.edu --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410

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
ffmpeg0.10 libnotify zenity
ttf-symbola

# remove desktop file electron adds -.-
rm "$HOME/.config/autostart/electron.desktop"

# add rambox autostart
cp "/usr/share/applications/rambox.desktop" "$HOME/.config/autostart"