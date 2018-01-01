# Installing Part 2 - Normal Partitioning

> This assumes that Part 1 is already done, and your sitting on the command prompt from finishing it

1. use ```lsblk``` to find a list of connected drives, note down the /dev/sdX of the drive(s) you want to install / format / partition, with the X being the drive letter.
1. Use ```cfdisk /dev/sdX``` to Partition the deivce as you wish
    1. Partition strategies - Need ~500mb boot partition (if your using UEFI, 2-3 MB if your using bios boot), the rest is up to you.
        * Note: I recommend /var is additionally split off into it's own ~5-10 GB partition, as the pacman cache can (rarely) fill up, leaving you unbootable
        1. Strategy 1 [device - size [mount point], [format to]
            * /dev/sdX1 - 500 MB /boot, format to fat32 **DO NOT FORMAT IF DUAL BOOTING**, it should already exist in that case, leave it alone, even if it's a bit small
            * /dev/sdX2 - [size of ram] swap partition, use ```mkswap``` on it later
            * /dev/sdX3 - [rest of drive] /, format to ext4 or xfs or something
        1. Strategy 2 [device - size [mount point], [format to]
            * /dev/sdX1 - 500 MB /boot, see above
            * /dev/sdX2 - [size of ram], see swap above
            * /dev/sdX3 - [at least 20 GB], /, see above
            * /dev/sdX4 - [rest of drive], /home, format the same as /, useful as you can reinstall the OS without reinstalling your user files
        1. Strategy 3 - "Split everything up approach" - You should probably look at LVM if your going to do this, also additionally [this](https://security.stackexchange.com/a/38803), if you want to be a tiny bit more secure [device - size [mount point], [format to]
            * /dev/sdX1 - 500 MB /boot, see above
            * /dev/sdX2 - [size of ram], see swap above
            * /dev/sdX3 - [at least 3-10GB] /, see above
            * /dev/sdX4 - [at least 5-10GB] /var, same as /
            * /dev/sdX5 - [at least 20GB] /usr (Arch defaults to /lib and some other directories point to this, so it gets decently big, same as /)
            * /dev/sdX6 - [at least 10GB[ /usr/bin (and /bin and /sbin, Arch defaults to /bin and /sbin being a link to /usr/bin - this contains all your pacman installed programs), format same as /
            * /dev/sdX7 - [~1GB] /etc, same as /
            * /dev/sdX8 - [~ around ram size (ish)] /tmp, same as /
            * /dev/sdX9 - [depends, can be as low as ~600MB, or as high as 20GB+] /opt (most programs don't install here, mostly from bigger non-linux first projects (e.g. my /opt has discord, teamviewer, visual-studio-code, android-sdk in it, using ~500MB), same as /
            */dev/sdX10 - [rest of drive] /home, see above
1. After using lsblk to format to whatever your strategy is, you have to format the drives
    * run ```mkfs.fat -F32 /dev/sdX1``` to format your boot partition **DO NOT DO THIS IF YOU ARE DUAL BOOTING**
    * run ```mkswap /dev/sdX2``` to format your swap partition, then use ```swapon /dev/sdX2``` to enable it
    * run ```mkfs.ext4 /dev/sdXn``` (or your ```mkfs.``` of [choice](https://wiki.archlinux.org/index.php/File_systems)) on your non-boot non-swap partitions
1. Mount the partitions to the designated spots
    * run ```mount /dev/sdXn /mnt``` to mount your root file system first
    * run ```mkdir -p /mnt/[location]``` and then ```mount /dev/sdXn /mnt/[location]``` to mount the rest, e.g. /boot would be ```mkdir -p /mnt/boot``` and then ```mount /dev/sdXn /mnt/boot```
1. Next, move on to ```3 - Pacstrap and Chroot```
