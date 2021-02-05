#!/bin/bash

function setup_firewall()
{
    cbecho "Setting up Uncomplicated Firewall"
    # https://wiki.debian.org/Uncomplicated%20Firewall%20%28ufw%29#Configuration
    sudo ufw enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
}
