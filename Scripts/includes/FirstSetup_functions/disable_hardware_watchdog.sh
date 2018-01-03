#!/bin/bash

# https://wiki.archlinux.org/index.php/Improving_performance#Watchdogs
function disable_hardware_watchdog()
{
    cbecho "Disabling hardware watchdog"
    echo "# Disable hardware watchdog, https://wiki.archlinux.org/index.php/Improving_performance#Watchdogs
blacklist iTCO_wdt" | sudo tee /etc/modprobe.d/bad-watchdog.conf 1>/dev/null
}