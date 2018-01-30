#!/bin/bash

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"

source "$INCLUDESLOC/colordefines.sh"

cbecho "Installing reflector and to handle Mirror Rank"

# install Reflector, which can rank mirrors, and reflector-timer, which does it on a timer
PACKAGES="reflector"
PACKAGESdeps="rsync"
sudo pacman -S --needed --noconfirm $PACKAGESdeps
sudo pacman -S --needed --noconfirm --asdeps $PACKAGESdeps

cbecho "Setting up reflector config"
echo -en "$GREEN What's your country? (2 letter code (or name), e.g. United States is US, Great Briten is GB, etc.): $RESET"
read COUNTRY

cecho "Writing Systemd Service / Timer"
# only using https, as it's more secure, hopefully there are enough mirrors, otherwise rsync?
echo "[Unit]
Description=Pacman mirrorlist update
Documentation=https://wiki.archlinux.org/index.php/Reflector
Requires=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/reflector --age 24 --country \"${COUNTRY}\" --latest 300 --number 50 --sort rate --save /etc/pacman.d/mirrorlist -p https -p http -p rsync -p ftp
" | sudo tee /etc/systemd/system/reflector.service 1>/dev/null

echo "[Unit]
Description=Weekly pacman mirrorlist refresh

[Timer]
OnCalendar=weekly
Persistent=true
AccuracySec=12h

[Install]
WantedBy=timers.target" | sudo tee /etc/systemd/system/reflector.timer 1> /dev/null


cbecho "Adding packman hook to update reflector after pacman-mirrorlist gets updated"
if [ ! -d /etc/pacman.d/hooks ]; then
    sudo mkdir /etc/pacman.d/hooks
fi

echo "[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew...
When = PostTransaction
Depends = reflector
Exec = /bin/sh -c \"sudo systemctl start reflector.service;  rm -f /etc/pacman.d/mirrorlist.pacnew\"" | sudo tee /etc/pacman.d/hooks/mirrorupgrade.hook 1>/dev/null


cbecho "Enabling reflector.timer in systemctl"
sudo systemctl enable reflector.timer
sudo systemctl start reflector.timer

cecho "Running reflector as otherwise it won't run for a week"
sudo systemctl start reflector.service
