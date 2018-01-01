#!/bin/sh

source includes/colordefines.sh

packages="cups gtk3-print-backends cups-pdf foomatic-d-engine gutenprint ghostscript gsfonts hplip splix foomatic-db-nonfree-ppds"
packagesDEPS="foomatic-db foomatic-db-ppds foomatic-db-gutenprint-ppds libusb"
echo -e "$CYAN Getting cups, foomatic, hp, and (older(?)) samsung drivers from normal repositories $RESET"
sudo pacman -S $packages --needed --noconfirm
echo -e "$CYAN Getting optional deps $RESET"
sudo pacman -S --asdeps $packagesDEPS --needed --noconfirm


echo -e "$CYAN Installing color profiles for splix (samsung printers) $RESET"
samsungdir="/usr/share/cups/profiles/samsung"
if [ ! -d "$samsungdir" ]; then
    mkdir $samsungdir
fi
curl http://splix.ap2c.org/samsung_cms.tar.bz2 | sudo tar xj -C $samsungdir

echo -e "$CYAN Installing canon, and epson drivers from the AUR $RESET"
aurPackages="capt-src epson-inkjet-printer-escpr"
trizen -S $aurPackages --needed --noconfirm

echo -e "$CYAN Trizen seems to have issues installing the samsung-unified-driver, it needs to install samsung-unified-driver-common, then -printer and -scanner, then finally the base package, you might have to manually do this step after the script finishes, we install the deps first because that seems to /mostly/ work $RESET"
trizen -S --asdeps samsung-unified-driver-printer --needed --noconfirm
trizen -S samsung-unified-driver --needed --noconfirm

echo -e "$CYAN Enabling / Starting CUPS $RESET"

sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service

echo
echo -e "$GREEN For help, visit https://wiki.archlinux.org/index.php/CUPS/Printer-specific_problems for overall printers $RESET"
echo -e "$GREEN       Canon CAPT: https://wiki.archlinux.org/index.php/Canon_CAPT $RESET"
echo -e "$GREEN       HP: https://wiki.archlinux.org/index.php/CUPS/Printer-specific_problems#HPLIP_Driver $RESET"
