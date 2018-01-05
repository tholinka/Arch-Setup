#!/bin/bash

setup_unbound()
{
    cbecho "Setting up unbound as local dns server / cache"

    cecho "Setting system resolver to use unbound"
    echo "nameserver ::1
nameserver 127.0.0.1" | sudo tee /etc/resolv.conf 1>/dev/null

    # protect /etc/resolv.conf so NetworkManager doesn't overwrite it
    sudo chattr +i /etc/resolv.conf

    cecho "Getting unbound root hints"
    sudo curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache

    cecho "Setting up unbound root.hint autorefresh using systemd"
    # https://wiki.archlinux.org/index.php/unbound#Roothints_systemd_timer
    echo "[Unit]
Description=Update root hints for unbound
After=network.target

[Service]
ExecStart=/usr/bin/curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache" | sudo tee /etc/systemd/system/roothints.service 1> /dev/null
    echo "[Unit]
Description=Run root.hints monthly

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=timers.target" | sudo tee /etc/systemd/system/roothints.timer 1>/dev/null

    cecho "Patching unbound.conf"
    sudo rm /etc/unbound/unbound.conf
    sudo cp /etc/unbound/unbound.conf.example /etc/unbound/unbound.conf

    echo "@@ -38 +38 @@
-	# num-threads: 1
+	num-threads: $(nproc --all)
@@ -159 +159 @@
-	# cache-min-ttl: 0
+	cache-min-ttl: 3600
@@ -216 +216 @@
-	# use-systemd: no
+	use-systemd: yes
@@ -220 +220 @@
-	# do-daemonize: yes
+	do-daemonize: no
@@ -295 +295 @@
-	# use-syslog: yes
+	use-syslog: yes
@@ -316 +316 @@
-	# root-hints: \"\"
+	root-hints: \"/etc/unbound/root.hints\"
@@ -319 +319 @@
-	# hide-identity: no
+	hide-identity: yes
@@ -322 +322 @@
-	# hide-version: no
+	hide-version: yes
@@ -350 +350 @@
-	# harden-glue: yes
+	harden-glue: yes
@@ -356 +356 @@
-	# harden-dnssec-stripped: yes
+	harden-dnssec-stripped: yes
@@ -375 +375 @@
-	# qname-minimisation: no
+	qname-minimisation: yes
@@ -397,7 +397,7 @@
-	# private-address: 10.0.0.0/8
-	# private-address: 172.16.0.0/12
-	# private-address: 192.168.0.0/16
-	# private-address: 169.254.0.0/16
-	# private-address: fd00::/8
-	# private-address: fe80::/10
-	# private-address: ::ffff:0:0/96
+	private-address: 10.0.0.0/8
+	private-address: 172.16.0.0/12
+	private-address: 192.168.0.0/16
+	private-address: 169.254.0.0/16
+	private-address: fd00::/8
+	private-address: fe80::/10
+	private-address: ::ffff:0:0/96
@@ -414 +414 @@
-	# unwanted-reply-threshold: 0
+	unwanted-reply-threshold: 10000000
@@ -467 +467,2 @@
-	# trust-anchor-file: \"\"
+	# --Note: pacman updates this
+	trust-anchor-file: \"trusted-key.key\"
@@ -610 +611 @@
-	# unblock-lan-zones: no
+	unblock-lan-zones: yes
@@ -614 +615 @@
-	# insecure-lan-zones: no
+	insecure-lan-zones: yes
@@ -751 +752 @@
-	# control-enable: no
+	control-enable: yes" | sudo patch -p0 -N /etc/unbound/unbound.conf

    cecho "Initializing unbound-control"
    sudo unbound-control-setup
}
