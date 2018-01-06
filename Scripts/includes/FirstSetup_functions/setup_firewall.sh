#!/bin/bash

function setup_firewall()
{
    cbecho "Setting up Uncomplicated Firewall"
    # https://wiki.debian.org/Uncomplicated%20Firewall%20%28ufw%29#Configuration
    # honestly not /really/ needed, and doesn't do /that/ much, but still nice to have set up
    sudo ufw enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    #sudo ufw allow qbittorrent
    #sudo ufw allow deluge
}