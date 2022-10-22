#!/bin/sh

# see https://jpft.win/docker-swarm-macvlan/ and https://github.com/jhpope/ansible-dns/commits/master for context

docker network create --scope swarm --attachable --subnet 192.168.1.0/24 -o parent=eth0 --gateway=192.168.1.1 pihole-macvlan
