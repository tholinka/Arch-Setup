# Installing Part 3 - Pacstrap and Chroot

> This assumes that Part 2 is already done, and your sitting on the command prompt with your partitions mount to /mnt.

1. run `pacstrap /mnt base base-devel`
    * You can also add on to that command to install other things, I'd recommend adding `git vim networkmanager`, and `intel-ucode` if you have an intel cpu.
    * e.g. `pacstrap /mnt base base-devel git vim networkmanager`.
2. Make fstab with `genfstab -U /mnt >> /mnt/etc/fstab`
3. chroot into the new install, `arch-chroot /mnt /bin/bash`
4. Uncomment `en_US.UTF-8 UTF-8` (or your locale, you can uncomment multiple) in `/etc/locale.gen` and then run `locale-gen` and then run `echo LANG=en_US.UTF-8 > /etc/locale.conf` (replace en_US.UTF-8 with your locale).
    * if you set your keyboard earlier (to anything non-us), make those changes perminent in by editing `/etc/vconsole.conf` to include `KEYMAP=[keymap setting]` and, after a newline `FONT=[font setting]`
5. Select a timezone, `tzselect` to find the timezone to use, and then `ln -s /usr/share/zoneinfo/[zone]/[subzone] /etc/localtime`, you may need to use `ln -sf` instead.
6. Set your hardware clock, if not dual booting with windows, use `hwclock --systohc --utc`.
    * This will "break" windows time (until it resyncs with NTP) if you are dual booting, see [this](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows).  Using the method in the wiki to configure windows to use utc will work for Windows 7 and later, but for older systems (or just for ease of configuration), instead run `hwclock --systohc --localtime`.  Note however this will cause the clock to be wrong if the daylight savings switch happens while the computer is offline (until it resyncs with NTP).
    * run `timedatectl` and see if the time is correct.  If it's not, and NTP is disabled, run `timedatectl set-ntp true`, or, optionally, set it manually.
7. Edit `/etc/mkinitcpio.conf`, the HOOKS= line
    * Convert mkinitcpio to using systemd (some installs see a speed increase with this)
      * Hooks line should read something like `base systemd autodetect modconf block filesystems resume fsck`, see [common hooks](https://wiki.archlinux.org/index.php/Mkinitcpio#Common_hooks)
    * Add `resume` right before fsck if you want to be able to hibernate.
      * This isn't suppose to be needed, since the `systemd` hook supports resuming, but it doesn't seem to work without it (this might be an lvm config issue?)
    * Add `sd-lvm2` after block if you're using lvm (e.g. `block sd-lvm2 filesystems`)
    * Regen the init with `mkinitcpio -p linux`
8. set up bootloader (systemd-boot), `bootctl install`, then configure it
    * Set `/boot/loader/loader.conf` to (each bullet point is a new line)
        * `default arch`
        * `timeout 5`
        * `editor 0`
    * Create /boot/loader/entries/arch.conf
        * `title   Arch Linux`
        * `linux   /vmlinuz-linux`
        * IF you have an intel cpu add: `initrd   /intel-ucode.img`
        * `initrd /initramfs-linux.img`
        * `options   root=[READ BELOW]`
            * IF you used lvm for part 2, set `options root=` to the location of your root partition logical volume, e.g. `/dev/mapper/VolGroup00-rootpart`
            * Otherwise, find your UUID by first knowing your /dev/sdXn of your root partition (use `fdisk -l` to find it), and then `ls /dev/disk/by-partuuid -l` and finding which uuid -> to your sdXn.  Write that down and edit that the options line to be `options root=PARTUUID=[your part uuid]` to it
            * If you have an nvidia graphics card, you may want to add ``nomodeset`` to the options, the nvidia drivers should fix this, but we don't install these until reboot
            * You can also add the following to quiet a lot of the bootup messages: `rw splash quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log-priority=3 nowatchdog`
            * Add `resume=PARTUUID=[your resume PARTUUID]` to enable hibernation / resume
9.  Set your hostname in `/etc/hostname`, set the file to the name, e.g. `Arch`
10. enable `NetworkManager.service` to ensure we get `nmcli` works on boot, `systemctl enable NetworkManager.service`
11. set the root password `passwd`
12. `exit` to exit the chroot, `umount -R /mnt` to unmount everything, and then `reboot` and pull out your usb drive
13. Continue to 4 - After rebooting if reboot was successful
