#!/bin/bash

CYAN="\e[36m"
GREEN="\e[32m"
DEFAULT="\e[39m"
BOLD="\e[1m"

RESET="\e[0m"

# use as general info
export CB="${CYAN}${BOLD}"
# use as prompts / things user has to do
export GB="${GREEN}${BOLD}"

function cecho()
{
    echo -e "${CYAN}${@}${RESET}"
}

function cbecho()
{
    echo -e "${CB}${@}${RESET}"
}