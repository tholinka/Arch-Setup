#!/bin/sh

function setup_sysctl()
{
    cbecho "Adding network core settings to sysctl"
    echo "# from https://wiki.archlinux.org/index.php/Sysctl#Improving_performance
# The maximum size of the receive queue.
# The received frames will be stored in this queue after taking them from the ring buffer on the NIC.
# Use high value for high speed cards to prevent loosing packets.
# In real time application like SIP router, long queue must be assigned with high speed CPU otherwise the data in the queue will be out of date (old).
net.core.netdev_max_backlog = 65536

# The maximum ancillary buffer size allowed per socket.
# Ancillary data is a sequence of struct cmsghdr structures with appended data.
net.core.optmem_max = 65536

# The default and maximum amount for the receive/send socket memory
# By default the Linux network stack is not configured for high speed large file transfer across WAN links.
# This is done to save memory resources.
# You can easily tune Linux network stack by increasing network buffers size for high-speed networks that connect server systems to handle more network packets.
net.core.rmem_default = 1048576
net.core.wmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384

# An extension to the transmission control protocol (TCP) that helps reduce network latency by enabling data to be exchanged during the sender’s initial TCP SYN.
# If both of your server and client are deployed on Linux 3.7.1 or higher, you can turn on fast_open for lower latency
net.ipv4.tcp_fastopen = 3

# The maximum queue length of pending connections 'Waiting Acknowledgment'
# In the event of a synflood DOS attack, this queue can fill up pretty quickly, at which point tcp_syncookies will kick in allowing your system to continue to respond to legitimate traffic, and allowing you to gain access to block malicious IPs.
# If the server suffers from overloads at peak times, you may want to increase this value a little bit.
net.ipv4.tcp_max_syn_backlog = 65536

# The maximum number of sockets in 'TIME_WAIT' state.
# After reaching this number the system will start destroying the socket in this state.
# Increase this to prevent simple DOS attacks
net.ipv4.tcp_max_tw_buckets = 65536

# Whether TCP should start at the default window size only for new connections or also for existing connections that have been idle for too long.
# It kills persistent single connection performance and should be turned off.
net.ipv4.tcp_slow_start_after_idle = 0

# Whether TCP should reuse an existing connection in the TIME-WAIT state for a new outgoing connection if the new timestamp is strictly bigger than the most recent timestamp recorded for the previous connection.
# This helps avoid from running out of available network sockets.
net.ipv4.tcp_tw_reuse = 1

# Fast-fail FIN connections which are useless.
net.ipv4.tcp_fin_timeout = 15

# TCP keepalive is a mechanism for TCP connections that help to determine whether the other end has stopped responding or not.
# TCP will send the keepalive probe contains null data to the network peer several times after a period of idle time. If the peer does not respond, the socket will be closed automatically.
# By default, TCP keepalive process waits for two hours (7200 secs) for socket activity before sending the first keepalive probe, and then resend it every 75 seconds. As long as there is TCP/IP socket communications going on and active, no keepalive packets are needed.
# With the following settings, your application will detect dead TCP connections after 120 seconds (60s + 10s + 10s + 10s + 10s + 10s + 10s)
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6

# The longer the MTU the better for performance, but the worse for reliability.
# This is because a lost packet means more data to be retransmitted and because many routers on the Internet can't deliver very long packets.
# Enable smart MTU discovery when an ICMP black hole detected.
net.ipv4.tcp_mtu_probing = 1

# Turn timestamps off to reduce performance spikes related to timestamp generation.
net.ipv4.tcp_timestamps = 0" | sudo tee /etc/sysctl.d/52-net-core.conf 1>/dev/null
}