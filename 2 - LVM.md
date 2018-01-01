# Installing Part 2 - [LVM](https://wiki.archlinux.org/index.php/LVM) partitioning

> This assumes that Part 1 is already done, and your sitting on the command prompt from finishing it.  This also assumes you've read through Part 2 - Normal, or at the very least know a bit about how partitions work.  About 90% of this is from the [LVM article](https://wiki.archlinux.org/index.php/LVM) in the arch wiki.

1. Pre-partition your drive into "non-lvm space" and "lvm space."  At a minimum you need a 500MB (UEFI) or 3MB (bios) boot partition that's not in lvm + a lvm partition.  See Part 2 - Normal for how to do this.  If this isn't a boot drive, you don't need a partition, point it to the entire disk instead.
    * You may need to run ```pacman -Sy lvm2 --needed``` to install lvm, but it should come with the install image
1. run ```lvmdiskscan``` to see lvm capable devices.
1. format (```mkfs.fat -F32 /dev/sdXn```) your boot partition if you have one. **DO NOT DO THIS IF YOU ARE DUAL BOOTING**
1. Create the physical volumes, run ```pvcreate /dev/sdX[n]``` on the partition(s) or device(s) your making into lvm, use ```pvdisplay```.  If your using a SSD with no partitions, use ```pvcreate --dataalignment 1m /dev/sdX``` [instead](https://serverfault.com/questions/356534/ssd-erase-block-size-lvm-pv-on-raw-device-alignment).
1. Next, create the volume group.  Note: this can contain multiple physical volumes.  ```vgcreate VolGroup00 /dev/sdX[n] [/dev/sdX[n]]```, you can have 1 or many physical volumes, just keep adding to that line.  Add other physical volumes later on using ```vgextend VolGroup00 /dev/sdX[n]```.  You can use any label instead of VolGroup00.  Check existing ones with ```vgdisplay```.
1. Next, create logical volumes through the following command: ```lvcreate -L <size (e.g. 10G)> <volume_group (e.g. VolGroup00)> -n <logical_volume (rootpart)>```.
    * This is lvm's version of normal partitions, see Part 2 - Normal for partitioning strategies.  Unlike normal partitions, these can be resized later.
    * The logical_volume, similiar to the volume_group, can have any name for example, you might want to name your /home partition ```home```
    * If you'd like to use up the remaining free space, use ```lvcreate -l 100%FREE  <volume_group> -n <logical_volume>``` (note the lower case l, instead of upper)
    * Track partitions using ```lvdisplay```
1. Now your partitions should be in /dev/mapper in the format of [VolumeGroup]-[LogicalVolume], and in /dev/[VolumeGroup] in the format of [LogicalVolume]
    * if they're not, try loading the modules for it, ```modprobe dm_mod``` to load the module, ```vgscan``` and ```vgchange -ay``` to load your volume groups.
1. You can now create the filesystems on them, e.g. ````mkfs.ext4 /dev/[VolumeGroup]/[LogicalVolume]```` and mount them, e.g. ```mount /dev/[VolumeGroup]/[LogicalVolume] /mnt```.  **DO NOT USE THE PHYSICAL VOLUME (e.g. /dev/sda2), USE THE VOLUME GROUPS**
    * See [File Systems](https://wiki.archlinux.org/index.php/File_systems) for filesystem types, and Part 2 - Normal for partition strategies.  Ext4 is probably good enough, since lvm can do snapshots, the filesystem doesn't have to.
1. Mount your partitions to your desired locations, and move on to ```3 - Pacstrap and Chroot```, note that we have to do some extra steps later on to let us boot.
