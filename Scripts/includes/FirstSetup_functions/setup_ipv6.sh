#!/bin/bash

function setup_ipv6()
{
	cbecho "Setting up ipv6"
	echo "Setting up privacy extensions"

	IPPRIV="# Enable IPv6 Privacy Extensions
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2"

	# need to get device names
	for i in $(echo /sys/class/net/* | sed 's|/sys/class/net/||g'); do
		# ignore lo, it's the loopback
		if [ "$i" = "lo" ]; then
			continue
		fi

		IPPRIV="$IPPRIV
net.ipv6.conf.$i.use_tempaddr = 2"
	done

	# networkmanager ignores this -.-, but we fix it in general_patches, https://wiki.archlinux.org/index.php/IPv6#NetworkManager
	echo "$IPPRIV" | sudo tee /etc/sysctl.d/40-ipv6.conf 1>/dev/null
}
