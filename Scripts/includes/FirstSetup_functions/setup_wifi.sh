#!/bin/bash

function setup_wifi()
{
    if [ -z ${WIFI+x} ]; then
        return 1;
    fi

    cbecho "Setting WiFi domain"

    echo -en "$C What's your country? (2 letter code, e.g. United States is US, Great Briten is GB, etc.): $RESET"
    read COUNTRY

    cecho "Setting Wireless Regdom to $COUNTRY"
    echo "WIRELESS_REGDOM=\"$COUNTRY\"" | sudo tee /etc/conf.d/wireless-regdom 1> /dev/null

    return 0
}