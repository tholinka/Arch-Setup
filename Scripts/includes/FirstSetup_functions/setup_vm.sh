#!/bin/sh

function setup_vm()
{
    if ! pacman -Q open-vm-tools &>/dev/null;  then
        return 1;
    fi

    echo -e "$CYAN Enabling vmware vmblock fuse $RESET"
    sudo systemctl enable vmware-vmblock-fuse.service

    # also enable vmware (open-vm-tools) suid wrapper
    echo -e "$CYAN Running user-suid wrapper $RESET"
    /usr/bin/vmware-user-suid-wrapper

    # set desktop file to autostart suid wrapper
    echo "[Desktop Entry]
Encoding=UTF-8
Name=VMware User SUID Wrapper
Comment=Enable VMware Communication (auto window resize, copy/paste, etc.) from within guest
TryExec=vmware-user-suid-wrapper
Exec=vmware-user-suid-wrapper
Icon=vmware-user-suid-wrapper
Type=Application
Categories=System;Utility;
StartupNotify=false
X-Desktop-File-Install-Version=0.22" > ~/.config/autostart/vmware-user-suid-wrapper.desktop
}