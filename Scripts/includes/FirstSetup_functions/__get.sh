#!/bin/bash

# pass in the first arg the package name
function __get()
{
    echo -en "$C $1 $RESET"
    read -p "$P" yn
    case $yn in
        [Yy]* )
            return 0
            ;;
    esac

    return 1
}