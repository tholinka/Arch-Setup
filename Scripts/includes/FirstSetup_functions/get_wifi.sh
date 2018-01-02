#!/bin/sh

# pass in a variable to set with package names
function get_wifi()
{
    if __get "WiFi"; then
        eval "$1='crda'"
        return 0
    fi

    return 1
}