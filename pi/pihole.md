# PiHole + Dnscrypt

PiHole for Ad Blocking

PiHole's built in dnsmasq for dns caching

Dnscrypt for secure dns

### A general system setup and aur access

1) Install needed packages:
    1) `pacman`: `dnscrypt-proxy`
    1) `pacman --asdeps`: `lighttpd php-cgi`
    1) `aur`: `pi-hole-server`
2) Set up `dnsmasq`
    1) Edit the following in ```/etc/dnsmasq.conf```
        * Add `min-cache-ttl=3600` somewhere (note: this is the max value dnsmasq allows, and _may_ cause issues with out of date domains, but it should be fine. At the very least you may want to set this to like 600 (10 mins) as some domains (google) keep very short default ttl, causing unneeded lookups)
        * Uncomment: `no-resolv`
        * Uncomment: `no-poll`
        * Set ```server=127.0.0.1#513```
        * Uncomment ```conf-dir=/etc/dnsmasq.d/,*.conf```
    2) In `/etc/dnsmasq.d/01-pihole.conf` and ```/etc/pihole/setupVars.conf```
        * Remove the `server=` lines
        * Remove the `interface=` lines if needed
        * Copy `02-disable-ipv6-on-some-domains.conf` into `/etc/dnsmasq.d/` if your on an ipv6 tunnel (as it then avoids ipv6 on those domains, therefore removing unnecessary tunneling)
3) Set up ```php``` in ```/etc/php/php.ini```
   1) Enable / uncomment the following extensions (e.g. remove the ```;``` in front of it)
       * ```extension=pdo_sqlite```
       * ```extension=sockets```
       * ```extension=sqlite3```
   2) Set (and uncomment) ```data.timezone = [America/Denver]```, see ```datetimectl``` to find your timezone
   3) Set (and uncomment) ```open_basedir``` to increase security, set to ```/srv/http/pihole:/run/pihole-ftl/pihole-FTL.port:/run/log/pihole/pihole.log:/run/log/pihole-ftl/pihole-FTL.log:/etc/pihole:/etc/hosts:/etc/hostname:/etc/dnsmasq.d/02-pihole-dhcp.conf:/etc/dnsmasq.d/03-pihole-wildcard.conf:/etc/dnsmasq.d/04-pihole-static-dhcp.conf:/proc/meminfo:/proc/cpuinfo:/sys/class/thermal/thermal_zone0/temp:/tmp```
4) Set up ```lighttpd```
    1) ```cp /usr/share/pihole/configs/lighttpd.example.conf /etc/lighttpd/lighttpd.conf```
    2) Enable/start ```lighttpd.service``` in ```systemctl```
5) Set up ```dnscrypt-proxy```
    1) Edit `/etc/dnscrypt-proxy/dnscrypt-proxy.toml`
        1) Change `listen_addresses` from port `53` to `513`
        2) Change `ipv6_servers` from `false` to `true` if you have ipv6 access (not tunneling).
        3) Change `require_dnssec` from `false` to `true`
        4) (Optional) Change `fallback_resolver` to something else, e.g. `1.1.1.1:53` (cloudflare dns, see https://1.1.1.1)
        5) Change `ignore_systemd_dns` to `true` (if dnscrypt-proxy needs a backup dns, the system one is down anyway)
        6) Change `cache` from `true` to `false` (dnsmasq handles this)
    2) Start/Enable ```dnscrypt-proxy.service``` in ```systemctl```
6) Set up ```pi-hole-ftl```
    1) Edit the following in ```/etc/pihole/pihole-FTL.conf```
        * Change ```SOCKET_LISTENING``` to ```all```
        * IF your on a solid state drive (e.g. ssd, sd card), set ```DBINTERVAL``` to ```60```
    2) Hardlink (or copy) `hosts` to `/etc/hosts` and edit as desired so that computer names are displayed instead of hostnames on the pihole web interface
    3) Restart ```pihole-FTL.service``` (it's statically enabled, don't enable it)
    4) run ```pihole -a -p``` and set a password
7) Allow pihole through firewall (commands assume ufw is being used)
    1) `ufw allow dns` to allow pihole/dnsmasq itself
    2) `ufw allow 513` to allow dnscrypt-proxy
    3) `ufw allow 80` to allow the web portal to work (optional: `ufw status numbered`, and then delete the ipv6 version of port 80)
    4) `ufw allow 4711` to allow the web portal to access the pihole api (optional: same as previous, except delete the ipv6 version of port 4711)
8) There you go, pihole should be running, you can check the management console by going to [ip]/admin in your browser
9) Run the `update-list.sh` and `whitelist.sh` scripts to setup the block lists and whitelists
10) Final thing: restart the pi to be safe, and set your router to use the pi for dns
