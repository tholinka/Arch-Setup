# PiHole + DNSMasq + Unbound + Dnscrypt
PiHole for adblock

Unbound for dns retreival

and Dnscrypt for secure dns

### This assumes you have trizen installed + a general system setup

1) Install needed packages:
    1) ```pacman```: ```dnscrypt-proxy php-sqlite```
    1) ```pacman --asdeps```: ```lighttpd php-cgi```
    1) ```trizen``` ```pi-hole-server```
1) Set up ```dnsmasq```
    1) Edit the following in ```/etc/dnsmasq.conf```
        * Uncomment: `no-resolv`
        * Uncomment: `no-poll`
        * Set ```server=127.0.0.1#513```
        * Uncomment ```conf-dir=/etc/dnsmasq.d/,*.conf```
    1) In ```/etc/dnsmasq.d/01-pihole.conf```
        * Comment out the ```servers=``` list
    1) Enable/Start ```dnsmasq.service``` using systemctl
1) Set up ```php``` in ```/etc/php/php.ini```
   1) Enable / uncomment the following extensions (e.g. remove the ```;``` in front of it)
       * ```extension=pdo_sqlite```
       * ```extension=sockets```
       * ```extension=sqlite3```
    1) Set (and uncomment) ```data.timezone = [America/Denver]```, see ```datetimectl``` to find your timezone
    1) Set (and uncomment) ```open_basedir``` to increase security, set to ```/srv/http/pihole:/run/pihole-ftl/pihole-FTL.port:/run/log/pihole/pihole.log:/run/log/pihole-ftl/pihole-FTL.log:/etc/pihole:/etc/hosts:/etc/hostname:/etc/dnsmasq.d/02-pihole-dhcp.conf:/etc/dnsmasq.d/03-pihole-wildcard.conf:/etc/dnsmasq.d/04-pihole-static-dhcp.conf:/proc/meminfo:/proc/cpuinfo:/sys/class/thermal/thermal_zone0/temp:/tmp```
1) Set up ```lighttpd```
    1) ```cp /usr/share/pihole/configs/lighttpd.example.conf /etc/lighttpd/lighttpd.conf```
    1) Enable/start ```lighttpd.service``` in ```systemctl```
1) Set up ```dnscrypt-proxy```
    1) Enable ```dnscrypt-proxy.service``` in ```systemctl``` (to create symlink to socket)
    1) Change the port it listens on to not conflict with unbound / dnsmasq
        1) Edit the ```dnscrypt-proxy.socket``` systemd service, ```systemctl edit dnscrypt-proxy.socket```
        1) Add the following (each bullet on a new line):
          * `[Socket]`
          * `ListenStream=`
          * `ListenDatagram=`
          * `ListenStream=127.0.0.1:513`
          * `ListenDatagram=127.0.0.1:513`
    1) Edit ```/etc/dnscrypt-proxy/dnscrypt-proxy.toml```
        1) Change ```ipv6_servers``` from ```false``` to ```true``` if you have ipv6 access.
        1) Change ```require_dnssec``` from ```false``` to ```true```
        1) Change ```fallback_resolver``` to ```1.1.1.1:53``` (cloudflare dns, see https://1.1.1.1)\
        1) Change ```listen_addresses``` to an empty array ```[]```
    1) Sandbox dnscrypt-proxy: `systemctl edit dnscrypt-proxy.service` (each bulletpoint is a new line)
      * `[Service]`
      * `CapabilityBoundingSet=CAP_IPC_LOCK CAP_SETGID CAP_SETUID CAP_NET_BIND_SERVICE`
      * `ProtectSystem=strict`
      * `ProtectHome=true`
      * `ProtectKernelTunables=true`
      * `ProtectKernelModules=true`
      * `ProtectControlGroups=true`
      * `PrivateTmp=true`
      * `PrivateDevices=true`
      * `MemoryDenyWriteExecute=true`
      * `NoNewPrivileges=true`
      * `RestrictRealtime=true`
      * `RestrictAddressFamilies=AF_INET AF_INET6`
      * `SystemCallArchitectures=native`
      * `SystemCallFilter=~@clock @cpu-emulation @debug @keyring @ipc @module @mount @obsolete @raw-io`
    1) Start/Enable ```dnscrypt-proxy.socket``` in ```systemctl```
1) Set up ```pi-hole-ftl```
    1) Edit the following in ```/etc/pihole/pihole-FTL.conf```
        * Change ```SOCKET_LISTENING``` to ```all```
        * IF your on a solid state drive (e.g. ssd, sd card), set ```DBINTERVAL``` to ```60```
    1) Restart ```pi-hole-ftl.service``` (it's statically enabled, don't enable it)
    1) run ```pihole -a -p``` and set a password
1) There you go, pihole should be running, you can check the management console by going to [ip]/admin in your browser
1) Final thing: restart the pi to be safe, and set your router to use the pi for dns
