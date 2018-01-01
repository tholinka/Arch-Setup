#!/bin/sh

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# systemd.timers
echo "[Unit]
Description=Check for low battery every 1m

[Timer]
OnBootSec=10
OnUnitActiveSec=1m

[Install]
WantedBy=timers.target" > /etc/systemd/system/low-battery.timer

# systemd.service
echo "[Unit]
Description=Hibernate if battery is low

[Service]
Type=oneshot
ExecStart=/etc/systemd/system/low-battery.sh" > /etc/systemd/system/low-battery.service

# low-battery.sh
echo "acpi -b | grep 'Battery 1' | awk -F'[,:%]' '{print $2, $3}' | {
     read -r status capacity
 
     msg=\"Battery is: \$status, \$capacity%\"
 
     if [ \"\$status\" = Discharging ] && [ \"\$capacity\" -lt 5 ]; then
         critMsg=\"Critical Battery Threshold.\"
 
         logger \"\$critMsg \$msg\"
         
         systemctl hibernate
     else
         logger \"Battery Not Low. \$msg\"
     fi
}" > /etc/systemd/system/low-battery.sh

chmod +x /etc/systemd/system/low-battery.sh

systemctl enable low-battery.timer
systemctl start low-battery.timer
