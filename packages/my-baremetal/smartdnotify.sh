#!/bin/sh

# Notify all console users
if command -v wall &>/dev/null; then
    wall "S.M.A.R.T. Error - $SMARTD_FAILTYPE - $SMARTD_MESSAGE" &>/dev/null
else
	echo "Failed to console notify, no wall"
fi

# notify all desktop environment users
if command -v notify-send &>/dev/null && command -v sudo &>/dev/null; then
for user in `who | grep -E "\(:[0-9](\.[0-9])*\)" | awk '{print $1 "@" $NF}' | sort -u`; do
    username=${user%@*}
    display=${user#*@}
    dbus=unix:path=/run/user/$(id -u $username)/bus

    sudo -u $username DISPLAY=${display:1:-1} \
                      DBUS_SESSION_BUS_ADDRESS=$dbus \
                      notify-send "S.M.A.R.T. Error ($SMARTD_FAILTYPE)" "$SMARTD_MESSAGE" --icon=dialog-error -u critical
done

else
	echo "Failed to desktop notify, no notify-send, sudo, awk, or w"
fi