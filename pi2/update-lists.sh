#!/bin/sh

# new sqlite approach based on https://discourse.pi-hole.net/t/blocklist-management-in-pihole-v5/31971/9

sudo sqlite3 /etc/pihole/gravity.db "DELETE FROM adlist"

#echo "Downloading adlist from wally3k.firebog.net"
#echo;
sudo curl "https://v.firebog.net/hosts/lists.php?type=tick" | xargs -I {} sudo sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (Address, Comment, Enabled) VALUES ('{}', 'firebog, added `date +%F`', 1);"

# used when firebog's website is having issues
#echo "Warning: using static list"
echo "https://hosts-file.net/grm.txt
https://reddestdream.github.io/Projects/MinimalHosts/etc/MinimalHostsBlocker/minimalhosts
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/KADhosts/hosts
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.Spam/hosts
https://v.firebog.net/hosts/static/w3kbl.txt
https://adaway.org/hosts.txt
https://v.firebog.net/hosts/AdguardDNS.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://hosts-file.net/ad_servers.txt
https://v.firebog.net/hosts/Easylist.txt
https://raw.githubusercontent.com/CHEF-KOCH/Spotify-Ad-free/master/Spotifynulled.txt
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/UncheckyAds/hosts
https://v.firebog.net/hosts/Airelle-trc.txt
https://v.firebog.net/hosts/Easyprivacy.txt
https://v.firebog.net/hosts/Prigent-Ads.txt
https://raw.githubusercontent.com/quidsup/notrack/master/trackers.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.2o7Net/hosts
https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/win10/spy.txt
https://v.firebog.net/hosts/Airelle-hrsk.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
https://mirror1.malwaredomains.com/files/justdomains
https://hosts-file.net/exp.txt
https://hosts-file.net/emd.txt
https://hosts-file.net/psh.txt
https://mirror.cedia.org.ec/malwaredomains/immortal_domains.txt
https://www.malwaredomainlist.com/hostslist/hosts.txt
https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt
https://v.firebog.net/hosts/Prigent-Malware.txt
https://v.firebog.net/hosts/Prigent-Phishing.txt
https://raw.githubusercontent.com/quidsup/notrack/master/malicious-sites.txt
https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt
https://v.firebog.net/hosts/Shalla-mal.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.Risk/hosts
https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist" &>/dev/null #| sudo xargs -I {} sudo sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (Address) VALUES ('{}');"

echo;
echo;
echo "Adding tholinka.github.io tracking lists"

echo "https://tholinka.github.io/projects/hosts/wintracking/normal
https://tholinka.github.io/projects/hosts/hosts" | xargs -I {} sudo sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (Address, Comment, Enabled) VALUES ('{}', 'tholinka.github.io, added `date +%F`', 1);"

echo;
echo "Running pihole gravity"
echo;

pihole -g
