# Setup script for Arch for the Pi 2

1) Login as the root account, either directly (e.g. ```ssh root@[ip]```, password is ```root```), or indirectly (e.g. ```ssh alarm@[ip]```, password is ```alarm```, then ```su``` to root)
1) ```echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/99_wheel_is_cool``` to enable wheel group to access sudo
1) ```pacman -Syu git base-devel zsh --needed``` to update / upgrade the system and also install git, sudo, base-devel, and zsh
1) ```useradd -m -g users -G wheel,alarm,power -s /bin/zsh 'username'``` to create a new user
    * it's a better idea to make your own account, but you _can_ just instead change the password, ```passwd```
1) exit out of ssh, and relogin using that new user, and then delete the old one ```userdel -r alarm```
1) Lock the root account, ```passwd -l root``
    * or, change it if you _really_ want to use the root account (seriously, you should lock it)
1) Updating locale:
    1) Uncomment your locale (and any others you want) in ```/etc/locale.gen``` (e.g. uncomment ```en_US.UTF-8 UTF-8```)
      * if you only want one locale, you can instead just echo to it, e.g. for en_US.UTF-8: ```echo LANG=en_US.UTF-8 | sudo tee /etc/locale.gen```
    1) then run ```sudo locale-gen```
    1) then echo your locale to /etc/locale.conf, this sets your perferred locale, e.g. for en_US.UTF-8, ```echo "en_US.UTF-8 UTF-8" | sudo tee /etc/locale.conf```
Note: at this point you can download dotfiles and set up zsh (zplug glitches on zsh themes if the locale isn't set)
1) Set the timerzone: Find out your timezone zone/subzone through ```tzselect```, and then manually link it using ```ln -sf /usr/share/zoneinfo/[zone]/[subzone] /etc/localtime```
    * you may want to check ```timedatectl``` to see if Network time or NTP sync is off, if it is, run ```timedatectl set-ntp true```.  This is normally unnecessary.
1) Change the hostname in ```/etc/hostname```
1) Change to using the hardware RNG generation
    1) Install ```rng-tools``` using ```pacman```
    1) Tell rngd where to find the hardware generation at by editing ```/etc/conf.d/rngd``` to include ```RNGD_OPTS="-o /dev/random -r /dev/hwrng"``` (currently tee'ing this works, as the file doesn't include anything else)
    1) disable / stop the systemctl ```haveged``` service
    1) enable / start the systemctl ```rngd``` service
1) Update mkinitcpio settings in ```/etc/mkinitcpio.conf:
    1) Change HOOKS line to ```HOOKS=(base systemd autodetect modconf block keyboard fsck filesystems)```
    1) run ```mkinitcpio -P``` to regen the image, having no modules is normal
1) Setup ```/etc/pacman.conf```: Uncomment ```#Color```
1) Setup ```/etc/makepkg.conf```:
    * (probably uneeded): Change the ```march``` setting of ```CFLAGS```, and ```CXXFLAGS``` to be instead ```march=native```
    * Change the makeflags line to: ```MAKEFLAGS="-j$(nproc --all)"```
1) Allow reboot: install ```polkit``` using pacman
1) At this point, you probably want to restart, because you probably got a new kernel when you updated earlier
1) Some of the general scripts are useful, including some of the first setup scripts (e.g. trizen), but unless you want graphics you probably don't want to run the firstsetup script (I really should refactor it to ask more questions on what to install)
    * The most useful are likely to be ```setup_aur```, ```setup_pacman_hooks```, ```setup_wifi```, ```setup_sysctl```, ```setup_ipv6```, ```setup_firewall```
      * Note, for setup_wifi you need to define a WIFI variable or it just immeditly exits
    * These included first setup scripts can be called pretty easily, for most of them, just ```source [script]``` then call the function
      * Source ```colordefines.sh``` first for the echo definitions it has
1) see [the pi wiki](https://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2) for more information, such as Audio over hdmi and gpio pins
