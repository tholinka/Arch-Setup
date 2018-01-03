#!/bin/bash

function setup_pacman_hooks()
{
    cbecho "Setting up pacman hooks"

    # need /etc/pacman.d/hooks
    if [ ! -d /etc/pacman.d/hooks ]; then
        sudo mkdir /etc/pacman.d/hooks
    fi

    ## from https://www.reddit.com/r/archlinux/comments/7k4ke8/reminder_run_paccache_r_everynow_and_then/drbkqby/
    # cleans all but the two most recent versions of package on upgade
    cecho "Setting up pacman hook to remove all but the two newest versions of a package on update"
    echo "[Trigger]
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache (upgrade, removing all but two most recent versions)...
When = PostTransaction
Exec = /usr/bin/paccache -rk2" | sudo tee /etc/pacman.d/hooks/paccache-upgrade.hook > /dev/null

    # clears all cached versions of a package on removal
    cecho "Setting up packman hook to remove all versions of a package on remove"
    echo "[Trigger]
Operation = Remove
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache (remove, removing all versions)...
When = PostTransaction
Exec = /usr/bin/paccache -ruk0" | sudo tee /etc/pacman.d/hooks/paccache-remove.hook > /dev/null
}