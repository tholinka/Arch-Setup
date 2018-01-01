# Installing Part 4 - After restart

> This assumes that Part 3 is already done and you restarted.    And that succeeded.

1. Login as root
1. add a new user: ```useradd -m -g users -G wheel,storage,power,input,lp -s /bin/bash 'username'```
    * set a password for this user, ```passwd [username]```
1. Add the ```wheel``` group to sudoers
    * echo '```%wheel ALL=(ALL) ALL' > /etc/sudoers.d/99_wheel_is_cool```
1. ```exit``` and login to your user account
1. ```ping google.com```, if you don't have a connection, repeat process from step 1
1. Clone this repository into something like .settings-git, ```git clone --recursive git@github.com:link07/Linux-Settings-and-Setup.git .settings-git
1. Run ```AurSetup.sh``` in ```Arch/Scripts``` to install trizen
1. Run ```FirstSetup.sh``` in ```Arch/Scripts``` to install other packages
1. configure installed packages
    1. switch to new kernel (if installed)
        * edit ```/boot/loader/loader.conf``` to default to linux-[kernel name], e.g. linux-zen
        * copy ```/boot/loader/config/arch.conf``` to arch-[kernel name].conf
        * add ```-[kernel name]``` to the vmlinuz and initramfs lines of the config
1. Reconfigure boot options to enable hibernate, and be quieter and faster
    * Add the following to the end of the ```options``` line in ```/boot/loader/[your config]```
        * ```rw splash quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log-priority=3``` to have startup / stop be show less information
        * ```resume=PARTUUID=[your swap partition's partuuid]``` to enable hibernation
    * For a marginal boot speed increase, edit ```/etc/fstab``` and remove the ```rw``` line from your ```/``` partition, as systemd will now do that instead
1. reboot again, you should reboot into a login menu.
    * for wifi, open up Settings -> Network and use that menu now
1. Continue to Part 5, misc setup
