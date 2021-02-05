#!/bin/bash

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/../includes"
source "$INCLUDESLOC/colordefines.sh"

# https://wiki.archlinux.org/index.php/Improving_performance#Watchdogs
cbecho "Disabling hardware watchdog"
echo "# Disable hardware watchdog, https://wiki.archlinux.org/index.php/Improving_performance#Watchdogs
blacklist iTCO_wdt" | sudo tee /etc/modprobe.d/bad-watchdog.conf 1>/dev/null
