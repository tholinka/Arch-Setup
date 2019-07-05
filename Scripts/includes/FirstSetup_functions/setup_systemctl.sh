#!/bin/bash

function setup_systemctl()
{
    cbecho "Enabling services in systemctl"
    cecho "Enabling sddm"
    sudo systemctl enable sddm.service

    cecho "Enabling NetworkManager (please manually disable wifi menu profiles through ${BOLD}systemctl disable netctl@<wifi-menu-profile>${NORMAL})"
    sudo systemctl enable NetworkManager.service
    sudo systemctl start NetworkManager.service

    ## unbound is not installed, using dnsmasq instead, which is handled by NetworkManager
    #cecho "Enabling unbound"
    #sudo systemctl enable unbound.service
    #sudo systemctl start unbound.service

    #cecho "Enabling unbound root hint updater"
    #sudo systemctl enable roothints.timer
    #sudo systemctl start roothints.timer


    cecho "Enabling cpupower"
    sudo systemctl enable cpupower.service
    sudo systemctl start cpupower.service

    # https://wiki.archlinux.org/index.php/improving_performance#irqbalance
    cecho "Enabling irqbalance"
    sudo systemctl enable irqbalance
    sudo systemctl start irqbalance

    cecho "Enabling Uncomplicated Firewall"
    sudo systemctl enable ufw
    sudo systemctl start ufw

	cecho "Enabling rngd"
	sudo systemctl enable rngd
	sudo systemctl start rngd

    if pacman -Q systemd-swap &>/dev/null; then
        # https://wiki.archlinux.org/index.php/zswap#Enabling_zswap
        cecho "Enabling systemd-swap (zswap)"
        sudo systemctl enable systemd-swap
        sudo systemctl start systemd-swap
    fi

    cecho "Disabling dhcpcd (NetworkManager uses dhclient)"
    sudo systemctl disable dhcpcd
    sudo systemctl stop dhcpcd # this'll kill active network connections
}
