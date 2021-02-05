# Installing Part 4 - After restart

> This assumes that Part 3 is already done and you restarted successfully.

1. Login as root
2. add a new user: `useradd -m -g users -G wheel,storage,power,input,lp,sys -s /bin/bash 'username'`
    * set a password for this user, `passwd [username]`
3. Add the `wheel` group to sudoers
   * `echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/99_wheel_is_cool`
4. `exit` and login to your user account
5. Lock the root account `passwd -l root`
6. `ping google.com`, if you don't have a connection, repeat process from step 1, using nmcli instead
   1. e.g. for wifi `nmcli dev wifi rescan`, then `nmcli dev wifi connect [SSID] passowrd [PASSWORD]`
7. Clone this repository into something like .arch-setup, `git clone https://github.com/tholinka/Arch-Setup.git .arch-setup`
8. Run `00` scripts in `scripts`, then install the meta packages in `packages`, finally run the other scripts in `scripts`
9. configure installed packages
    1. switch to new kernel (if installed)
      * copy `/boot/loader/config/arch.conf` to `arch-[kernel name].conf`
      * edit `/boot/loader/loader.conf` to default to `linux-[kernel name]`, e.g. linux-zen
      * add `-[kernel name]` to the `vmlinuz` and `initramfs` lines of the config
10. reboot again, you should reboot into a login menu.
    * for wifi, open up Settings -> Network and use that menu now

## Some post-install notes

* The themes I use are:
  * breeze dark
  * from aur:
    * xcursor-human
