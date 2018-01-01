#!/bin/sh

source includes/colordefines.sh

# get trizen if it's not installed
if ! which trizen &> /dev/null; then
	echo -e "${CYAN}Cloning Trizen's AUR repo${DEFAULT}"

	git clone https://aur.archlinux.org/trizen.git
	cd trizen

	echo
	echo -e "${CYAN}Making Trizen${DEFAULT}"
	echo

	makepkg -si
	cd - 1>/dev/null
	rm trizen -rf

	echo -e "${CYAN}Installing Trizen optional deps${DEFAULT}"
	sudo pacman -S --asdeps perl-json-xs perl-term-readline-gnu

	echo
	echo -e "${CYAN}Trizen is installed${DEFAULT}"
else
	echo -e "${CYAN}Trizen is already installed!${DEFAULT}"
fi