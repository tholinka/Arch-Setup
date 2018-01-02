#!/bin/sh

# pass in a variable to get kernel name, returns true (0) if zen or hardned set, otherwise returns false (1)
function get_kernel()
{
    cecho "Choose Kernel [Linux-Zen, Linux-Hardened]"

    norm="linux"
    zen="${norm}-zen"
    hard="${norm}-hardened"

    if __get "Linux Zen"; then
        eval "$1='$zen'"
        return 0
    fi

    if __get "Linux Hardened"; then
        eval "$1='$hard'"
        return 0
    fi

    eval "$1='$norm'"

    return 1
}

