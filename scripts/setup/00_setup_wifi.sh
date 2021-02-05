#!/bin/bash

# find script location so we can get includes
SCRIPTSLOC=$(dirname "$0")
INCLUDESLOC="$SCRIPTSLOC/../includes"
source "$INCLUDESLOC/colordefines.sh"

cbecho "Setting WiFi domain"

echo -en "$C What's your country? (2 letter code, e.g. United States is US, Great Briten is GB, etc.): $RESET"
read COUNTRY

cecho "Setting Wireless Regdom to $COUNTRY"
echo "WIRELESS_REGDOM=\"$COUNTRY\"" | sudo tee /etc/conf.d/wireless-regdom 1> /dev/null
