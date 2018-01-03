#!/bin/bash

# get trizen if it's not installed
function setup_aur()
{
    cecho "Installing trizen (aur helper)"
    if which trizen &> /dev/null; then
        cecho "Trizen is already installed (skipping)"
        return 0
    fi

	cbecho "Setting up AUR (Trizen)"

    cecho "Cloning Trizen's AUR repo to /tmp"
    git clone https://aur.archlinux.org/trizen.git /tmp/trizen
	cd /tmp/trizen

	echo
	cecho "Making Trizen"
	echo

	makepkg -si
	cd - 1>/dev/null
	rm trizen -rf

	cecho "Installing Trizen optional deps"
	sudo pacman -S --asdeps perl-json-xs perl-term-readline-gnu

	echo
    cecho "Trizen is installed"
}