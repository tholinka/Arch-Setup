# Installing Part 4 - After restart

> This assumes that Part 3 is already done and you restarted.    And that succeeded.

1. Login as root
1. add a new user: `useradd -m -g users -G wheel,storage,power,input,lp,sys -s /bin/bash 'username'`
    * set a password for this user, `passwd [username]`
1. Add the `wheel` group to sudoers
    * `echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/99_wheel_is_cool`
1. `exit` and login to your user account
1. Lock the root account `passwd -l root`
1. `ping google.com`, if you don't have a connection, repeat process from step 1, using nmcli instead
   1. e.g. for wifi `nmcli dev wifi rescan`, then `nmcli dev wifi connect [SSID] passowrd [PASSWORD]`
2. Clone this repository into something like .arch-setup, `git clone --recursive https://github.com/tholinka/Arch-Setup.git .arch-setup`
3. Run `FirstSetup.sh` in `Scripts` to install automatically set up most of the system
4. configure installed packages
    1. switch to new kernel (if installed)
        * edit `/boot/loader/loader.conf` to default to linux-[kernel name], e.g. linux-zen
        * copy `/boot/loader/config/arch.conf` to arch-[kernel name].conf
        * add `-[kernel name]` to the vmlinuz and initramfs lines of the config
5. Reconfigure boot options to enable hibernate, and be quieter and faster (you might have done this in part 3)
    * Add the following to the end of the `options` line in `/boot/loader/[your config]`
        * `rw splash quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log-priority=3` to have startup / stop be show less information
        * `nowatchdog` to [disable the software watchdog](https://wiki.archlinux.org/index.php/Improving_performance#Watchdogs)
        * `resume=PARTUUID=[your swap partition's partuuid]` to enable hibernation
6. `etc/fstab` edits
  * For a marginal boot speed increase, edit `/etc/fstab` and remove the `rw` line from your `/` partition, as systemd will now do that instead
  * Also, if you're using btrfs, you can specify compression and compress level, e.g. `compress=zstd:15`
    * e.g. your full `fstab` entry for `/` might be `relatime,ssd,space_cache,compress=zstd:15,subvolid=5,subvol=/`
7. reboot again, you should reboot into a login menu.
    * for wifi, open up Settings -> Network and use that menu now
8. Continue to Part 5, misc setup
