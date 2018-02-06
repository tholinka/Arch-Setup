# Setup script for Arch for the Pi 2

1) Login as the root account, either directly (e.g. ```ssh root@[ip]```, password is ```root```), or indirectly (e.g. ```ssh alarm@[ip]```, password is ```alarm```, then ```su``` to root)
1) ```echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/99_wheel_is_cool``` to enable wheel group to access sudo
1) ```pacman -Syu git sudo``` to update / upgrade the system and also install git and sudo
