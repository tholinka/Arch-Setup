#!/bin/bash

# get yay if it's not installed
function setup_aur()
{
    cecho "Installing yay (aur helper)"
    if which yay &> /dev/null; then
        cecho "yay is already installed (skipping)"
        return 0
    fi

	cbecho "Setting up AUR (yay)"

    cecho "Cloning yay's AUR repo to /tmp"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
	cd /tmp/yay

	echo
	cecho "Making yay"
	echo

	makepkg -si --noconfirm --needed
	cd - 1>/dev/null

	echo
    cecho "yay is installed"
}
