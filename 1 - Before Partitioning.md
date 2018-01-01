# Installing Part 1 - Before Partitioning

> Note: You may find it easier to skip this, go to partitioning, do that in [GParted live](http://gparted.org/), and then come back and do this

1. Get the [arch image](https://www.archlinux.org/download/).
1. Put it on a usb ([dd](https://wiki.archlinux.org/index.php/USB_flash_installation_media) or [yumi](https://www.pendrivelinux.com/yumi-multiboot-usb-creator/) (use the UEFI version of yumi if you want to install using systemd-boot / UEFI)
1. reboot computer with usb drive in, select usb from bios / boot menu
1. You should boot into the Arch image.
    * if your screen instead looks corrupted, reboot and hit 'e' on the boot manager screen and add "nomodeset" to the end.
        * If you don't see one, shut off the computer, mount the install drive on a different one (e.g. ```sudo mount /dev/sdX2 /mnt```) and edit the line ```initrd  /EFI/archiso/archiso.img``` in ```/mnt/loader/entries/archiso-x86_64.conf``` to ```initrd  /EFI/archiso/archiso.img nomodeset```
1. See if your in UEFI mode by running: ```ls /sys/firmware/efi/efivars```, if the directory has contents your in UEFI mode.  If not, don't use systemd-boot, use grub instead.
1. run ```load-keys [country e.g. us]```. The default is the us, see available ones in ```ls /usr/share/kbd/keymaps/**/*.map.gz```, you might have to change the font if some characters don't display, through ```etfont lat9w-16``` or other font.
1. connect to the internet, if your using ethernet, see if it's already working through ```ping google.com```
    * if your not connected, try ```ip addr``` to see currently connected network interfaces
        * check ```lspci -k``` and ```dmesg``` to see a list of drivers, look for "Network controller", specifically the kernel module line, if you don't see it, it's not detected
    * using wifi
        * get wifi interface from above step, and then run ```wifi-menu -o [device name]```
        * if that doesn't connect, ```ip link set [device name] up```, scan for access points ```iw dev interface scan | less```, connect to the wifi through wpa_supplicant, ```wpa_supplicant -B -i wlan0 -c <(wpa_passphrase "your_SSID" "your_key")```, remove -B to check to make sure it connects, as that sends the process to the background.  Then start the dhcp service on the interface to get a ip address, ```systemctl restart dhcpcd.service```
        * Check [here](https://wiki.archlinux.org/index.php/Wireless_network_configuration) for more help.
1. Update system clock, ```timedatectl set-ntp true```
1. Partitioning time, go to ```2 - LVM``` if your using [Logical Volume manager](https://wiki.archlinux.org/index.php/LVM), or ```2 - Standard``` for normal partitioning
