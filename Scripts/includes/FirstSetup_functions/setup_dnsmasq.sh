#!/bin/sh
setup_dnsmasq()
{
    cbecho "Setting up dnsmasq as local dns server / cache"

    cecho "Patching dnsmasq.conf"
    echo "@@ -46 +46 @@
-#resolv-file=
+resolv-file=/etc/resolv.dnsmasq.conf
@@ -111 +111 @@
-#listen-address=
+listen-address=127.0.0.1" | sudo patch -p0 -N /etc/dnsmasq.conf

    cecho "Setting system resolver to use dnsmasq"
    echo "nameserver 127.0.0.1
nameserver ::1
options timeout:1" | sudo tee /etc/resolv.conf 1>/dev/null

    # protect /etc/resolv.conf so NetworkManager doesn't overwrite it
    sudo chattr +i /etc/resolv.conf

    DNS_RESOLV_LOC="/etc/resolv.dnsmasq.conf"
    cecho "Setting dnsmasq's servers (you may want to edit these, view them at $DNS_RESOLV_LOC)"
    echo "# OpenNIC IPv4 nameservers (Worldwide Anycast)
nameserver 185.121.177.177
nameserver 169.239.202.202

# OpenNIC IPv6 nameservers (Worldwide Anycast)
nameserver 2a05:dfc7:5::53
nameserver 2a05:dfc7:5::5353

# few US OpenNIC servers, since the anycasts can have lag spikes, might want to manually configure these, go to https://www.opennic.org/ to find the closest servers, and then maybe but this above the anycast
# no logs, DNScrypt
nameserver 128.52.130.209
nameserver 2001:470:1f06:10b::2
# no logs
nameserver 172.98.193.42
# anon logs
nameserver 69.195.152.204
nameserver 162.248.241.94

# and a couple global ones
# anon logs, DNScrypt
nameserver 185.121.177.177
nameserver 2a05:dfc7:5::53
nameserver 169.239.202.202
nameserver 2a05:dfc7:5353::53

# dns.watch servers
nameserver 84.200.69.80
nameserver 84.200.70.40
nameserver 2001:1608:10:25::1c04:b12f
nameserver 2001:1608:10:25::9249:d69b

# google fallback
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844

# router dns (to get local things, edit these to your routers, these are a list of general ones to try)
nameserver 192.168.1.1
nameserver 192.168.0.1

options timeout:1" | sudo tee "$DNS_RESOLV_LOC" 1>/dev/null
}