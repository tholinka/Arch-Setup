#!/bin/bash

# get paru if it's not installed
function setup_aur()
{
    cecho "Installing paru (aur helper)"
    if which paru &> /dev/null; then
        cecho "paru is already installed (skipping)"
        return 0
    fi

	cbecho "Setting up AUR (paru])"

    cecho "Cloning paru's AUR repo to /tmp"
    git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
	cd /tmp/paru

	echo
	cecho "Making paru"
	echo

	makepkg -si --noconfirm --needed
	cd - 1>/dev/null

	echo
    cecho "paru is installed"
}
