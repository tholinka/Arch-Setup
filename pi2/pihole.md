# PiHole + DNSMasq + Unbound + Dnscrypt
PiHole for adblock

Unbound for dns retreival

and Dnscrypt for secure dns

### This assumes you have trizen installed + a general system setup

1) Install needed packages:
    1) ```pacman```: ```dnscrypt-proxy php-sqlite```
    1) ```pacman --asdeps```: ```lighttpd php-cgi```
    1) ```trizen```: ```pi-hole-server```
1) Set up ```dnsmasq```
    1) Edit the following in ```/etc/dnsmasq.conf```
        * Add `min-cache-ttl=3600` somewhere (note: this is the max value dnsmasq allows, and _may_ cause issues with out of date domains, but it should be fine. At the very least you may want to set this to like 600 (10 mins) as some domains (google) keep very short default ttl, causing unneeded lookups)
        * Uncomment: `no-resolv`
        * Uncomment: `no-poll`
        * Set ```server=127.0.0.1#513```
        * Uncomment ```conf-dir=/etc/dnsmasq.d/,*.conf```
    1) In `/etc/dnsmasq.d/01-pihole.conf` and ```/etc/pihole/setupVars.conf```
        * Remove the `server=` lines
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
    1) Edit `/etc/dnscrypt-proxy/dnscrypt-proxy.toml`
        1) Change `listen_addresses` from port `53` to `513`
        1) Change `ipv6_servers` from `false` to `true` if you have ipv6 access.
        1) Change `require_dnssec` from `false` to `true`
        1) Change `timeout` to something lower (e.g. `1000`) (or leave it if your connection is pretty spotty)
        1) (Optional) Change `fallback_resolver` to something else, e.g. `1.1.1.1:53` (cloudflare dns, see https://1.1.1.1)\
        1) Change `ignore_systemd_dns` to `true` (if dnscrypt-proxy needs a backup dns, the system one is down anyway)
        1) Change `cache` from `true` to `false` (dnsmasq handles this)
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
    1) Start/Enable ```dnscrypt-proxy.service``` in ```systemctl```
1) Set up ```pi-hole-ftl```
    1) Edit the following in ```/etc/pihole/pihole-FTL.conf```
        * Change ```SOCKET_LISTENING``` to ```all```
        * IF your on a solid state drive (e.g. ssd, sd card), set ```DBINTERVAL``` to ```60```
    1) Restart ```pi-hole-ftl.service``` (it's statically enabled, don't enable it)
    1) run ```pihole -a -p``` and set a password
1) There you go, pihole should be running, you can check the management console by going to [ip]/admin in your browser
1) Final thing: restart the pi to be safe, and set your router to use the pi for dns
