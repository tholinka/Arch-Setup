#!/bin/bash

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/includes"

source "$INCLUDESLOC/colordefines.sh"

packages="cups gtk3-print-backends cups-pdf foomatic-db-engine gutenprint ghostscript gsfonts hplip splix foomatic-db-nonfree-ppds"
packagesDEPS="foomatic-db foomatic-db-ppds foomatic-db-gutenprint-ppds libusb"
cecho "Getting cups, foomatic, hp, and (older(?)) samsung drivers from normal repositories"
sudo pacman -S $packages --needed --noconfirm
cecho "Getting optional deps"
sudo pacman -S --asdeps $packagesDEPS --needed --noconfirm


cecho "Installing color profiles for splix (samsung printers)"
samsungdir="/usr/share/cups/profiles/samsung"
mkdir -p $samsungdir
curl http://splix.ap2c.org/samsung_cms.tar.bz2 | sudo tar xj -C "$samsungdir"

cecho "Installing canon, and epson drivers from the AUR"
aurPackages="capt-src epson-inkjet-printer-escpr"
yay -S $aurPackages --needed --noconfirm

cecho "Trizen seems to have issues installing the samsung-unified-driver, it needs to install samsung-unified-driver-common, then -printer and -scanner, then finally the base package, you might have to manually do this step after the script finishes, we install the deps first because that seems to /mostly/ work"
yay -S --asdeps samsung-unified-driver-printer --needed --noconfirm
yay -S samsung-unified-driver --needed --noconfirm

cecho "Enabling / Starting CUPS"

sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service

echo
echo -e "$GREEN For help, visit https://wiki.archlinux.org/index.php/CUPS/Printer-specific_problems for overall printers $RESET"
echo -e "$GREEN       Canon CAPT: https://wiki.archlinux.org/index.php/Canon_CAPT $RESET"
echo -e "$GREEN       HP: https://wiki.archlinux.org/index.php/CUPS/Printer-specific_problems#HPLIP_Driver $RESET"
