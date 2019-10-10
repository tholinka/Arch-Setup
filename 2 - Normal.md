# Installing Part 2 - Normal Partitioning

> This assumes that Part 1 is already done, and your sitting on the command prompt from finishing it

1. use `lsblk` to find a list of connected drives, note down the /dev/sdX of the drive(s) you want to install / format / partition, with the X being the drive letter.
1. Use `cfdisk /dev/sdX` (or similar) to Partition the device as you wish
    1. Partition strategies - Need ~500mb boot partition (if your using UEFI, 2-3 MB if your using bios boot), the rest is up to you.
        * Note: I would recommend against partitioning /tmp and /run, as arch defaults to a [tmpfs](https://wiki.archlinux.org/index.php/tmpfs) for them.
        * Generally required partitions
          * `/boot`: 300-500MB
            * format with `mkfs.fat -F32`
            * **DO NOT FORMAT IF DUAL BOOTING**, it should already exist in that case, leave it alone.
          * swap: [size of ram]
            * use `mkswap` and `swapon` on it
          * `/`: [rest of disk]
            * format to `ext4`, `btrfs`, `xfs`, etc with `mkfs.[choice] /dev/[partition]`
        * Optional partitions (or subvolumes if using `btrfs`):
          * `/home`
          * `/var`, pacman cache can (rarely) fill this up and leave the system unbootable
          * `/usr`
          * `/etc`
          * `/opt`
          * `/usr/bin` - probably not really needed, arch will point `/bin`, `/sbin`, and `/usr/sbin` to this.
1. Mount the partitions to the designated spots
    * run `mount /dev/sdXn /mnt` to mount your root file system first
      * if your using btrfs, you might want to mount with the option of `compress=[compression]:[level]`, so that the pacstrap will get compressed.
        * e.g. add the following to the mount command `-o compress=zstd:15`
    * run `mkdir -p /mnt/[location]` and then `mount /dev/sdXn /mnt/[location]` to mount the rest, e.g. `/boot` would be `mkdir -p /mnt/boot` and then `mount /dev/sdXn /mnt/boot`
1. Next, move on to `3 - Pacstrap and Chroot`
