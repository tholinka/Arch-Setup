#!/bin/sh

function setup_systemctl()
{
    cbecho "Enabling services in systemctl"
    cecho "Enabling lightdm"
    sudo systemctl enable lightdm.service

    cecho "Enabling NetworkManager (please manually disable wifi menu profiles through ${BOLD}systemctl disable netctl@<wifi-menu-profile>${NORMAL})"
    sudo systemctl enable NetworkManager.service
    sudo systemctl start NetworkManager.service

    cecho "Enabling unbound"
    sudo systemctl enable unbound.service
    sudo systemctl start unbound.service

    cecho "Enabling cpupower"
    sudo systemctl enable cpupower.service
    sudo systemctl start cpupower.service

    # https://wiki.archlinux.org/index.php/improving_performance#irqbalance
    cecho "Enabling irqbalance"
    sudo systemctl enable irqbalance
    sudo systemctl start irqbalance

    cecho "Disabling dhcpcd (NetworkManager uses dhclient)"
    sudo systemctl disable dhcpcd
    sudo systemctl stop dhcpcd
}