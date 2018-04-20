#!/bin/sh

echo "Download adlist from wally3k.firebog.net"
echo;

sudo curl "https://v.firebog.net/hosts/lists.php?type=tick" -o /etc/pihole/adlists.list

echo;
echo;
echo "Adding windows tracking list"

echo "https://link07.github.io/projects/hosts/wintracking/normal" | sudo tee -a /etc/pihole/adlists.list >/dev/null

echo;
echo "Running pihole gravity"
echo;

pihole -g
