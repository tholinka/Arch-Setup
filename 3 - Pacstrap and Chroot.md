# Installing Part 3 - Pacstrap and Chroot

> This assumes that Part 2 is already done, and your sitting on the command prompt with your partitions mounted to /mnt.

1. run `pacstrap /mnt base [SEE OTHER REQUIRED OPTIONS BELOW]`
    * Since `base` is now a meta package, several key things were removed, as such, choose one from each of the follow:
      * kernel
        * `linux`, `linux-lts`, `linux-zen`, etc
        * You probably also want `linux-firmware` if using a kernel that has it marked as an optional, but you may want to wait until after the `arch-chroot` to `--asdeps` install it.
      * text editor
        * `vim`, `neovim`, etc
      * network
        * `networkmanager`, etc
      * ucode (intel and amd only)
        * `intel-ucode` or `amd-ucode`
    * some other helpful things you may want to add:
      * `git`
      * `base-devel` (although there is a meta package for this in the packages folder, so you may want to wait to use that instead)
      * `btrfs-progs` if you're using btrfs
    * e.g. `pacstrap /mnt base linux-zen vim networkmanager git`
1. Make fstab with `genfstab -U /mnt >> /mnt/etc/fstab`
   * `/mnt/etc/fstab` edits
     * For a marginal boot speed increase, edit `/etc/fstab` and remove the `rw` line from your `/` partition, as systemd will now do that instead
     * `btrfs` changes
       * You may want to specify a compression and compression level, e.g. `compress=zstd:15`
       * e.g. your full `fstab` entry for a `btrfs` filesystem might be `relatime,autodefrag,compress=zstd:15,subvolid=5,subvol=/`
         * `ssd` or `nossd` might be useful, but it should get autodetected
         * `space_cache=v2` might be useful in the future when the `btrfs` command gets better (non-read-only) support for it, but right now `v1` is the default.
1. chroot into the new install, `arch-chroot /mnt /bin/bash`
   * you may want to install `pacman -S --asdeps --needed` a few things
     * `base-devel`: if you plan to use the meta package later and haven't installed it yet
     * `linux-firmware`: if your kernel has it marked as an optional
1. Uncomment `en_US.UTF-8 UTF-8` (or your locale, you can uncomment multiple) in `/etc/locale.gen` and then run `locale-gen` and then run `echo LANG=en_US.UTF-8 > /etc/locale.conf` (replace en_US.UTF-8 with your locale).
    * if you set your keyboard earlier (to anything non-us), make those changes perminent in by editing `/etc/vconsole.conf` to include `KEYMAP=[keymap setting]` and, after a newline `FONT=[font setting]`
1. Select a timezone, `tzselect` to find the timezone to use, and then `ln -s /usr/share/zoneinfo/[zone]/[subzone] /etc/localtime`, you may need to use `ln -sf` instead.
1. Set your hardware clock, if not dual booting with windows, use `hwclock --systohc --utc`.
    * This will "break" windows time (until it resyncs with NTP) if you are dual booting, see [this](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows).  Using the method in the wiki to configure windows to use utc will work for Windows 7 and later, but for older systems (or just for ease of configuration), instead run `hwclock --systohc --localtime`.  Note however this will cause the clock to be wrong if the daylight savings switch happens while the computer is offline (until it resyncs with NTP).
    * run `timedatectl` and see if the time is correct.  If it's not, and NTP is disabled, run `timedatectl set-ntp true`, or, optionally, set it manually.
1. Edit `/etc/mkinitcpio.conf`, the HOOKS= line
    * Convert `mkinitcpio` to using `systemd` (some installs see a speed increase with this)
      * Hooks line should read something like `base systemd autodetect modconf block filesystems resume fsck`, see [common hooks](https://wiki.archlinux.org/index.php/Mkinitcpio#Common_hooks)
    * Add `resume` right before `fsck` if you want to be able to hibernate.
      * This isn't suppose to be needed, since the `systemd` hook supports resuming, but it doesn't seem to work without it (this might be an lvm config issue?)
    * Add `sd-lvm2` after block if you're using lvm (e.g. `block sd-lvm2 filesystems`)
    * Regen the init with `mkinitcpio -p linux`
1. set up bootloader (systemd-boot), `bootctl install`, then configure it
    * Set `/boot/loader/loader.conf` to (each bullet point is a new line)
        * `default arch`
        * `timeout 5`
        * `editor 0`
    * Create /boot/loader/entries/arch.conf
      * `title   Arch Linux`
      * `linux   /vmlinuz-linux`
      * Add intel / amd ucode if applicable
        * `initrd   /[intel|amd]-ucode.img`
      * `initrd /initramfs-linux.img`
      * `options  [space separated list of things from below]`
        * `root=[READ BELOW]`
          * IF you used lvm for part 2, set `options root=` to the location of your root partition logical volume, e.g. `/dev/mapper/VolGroup00-rootpart`
          * Otherwise, find your UUID by first knowing your /dev/sdXn of your root partition (use `fdisk -l` to find it), and then `ls /dev/disk/by-partuuid -l` and finding which uuid -> to your sdXn.  Write that down and edit that the options line to be `options root=PARTUUID=[your part uuid]` to it.
            * a useful way to insert this is to find your `partuuid` and then run `ls /dev/disk/by-partuuid | grep [first three characters of your partuuid] >> arch.conf`, then you can just delete the extra newline
        * If you have an nvidia graphics card, you may want to add `nomodeset` the nvidia drivers should fix this, but we don't install these until reboot
        * Optional stuff:
          * `rw splash quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log-priority=3` to have startup / stop be show less information
          * `nowatchdog` to [disable the software watchdog](https://wiki.archlinux.org/index.php/Improving_performance#Watchdogs)
          * `resume=PARTUUID=[your swap partition's partuuid]` to enable hibernation
1. Set your hostname in `/etc/hostname`, set the file to the name, e.g. `Arch`
1. enable `NetworkManager.service`
1. set the root password `passwd` (optional, since we lock the root later anyway)
1. `exit` to exit the chroot, `umount -R /mnt` to unmount everything, and then `reboot` and pull out your usb drive
1. Continue to 4 - After rebooting if reboot was successful
