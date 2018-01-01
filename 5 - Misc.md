1. Enable chromium hardware accel
    * chrome://flags/#ignore-gpu-blacklist -> enable
    * chrome://flags/#enable-gpu-rasterization -> enable (this might break some websites fonts)
    * chrome://flags/#enable-zero-copy -> enable
1. Enable nightlight / flux.  Install ```redshift plasma5-applets-redshift-control``` and then ```right click on the task bar -> unlock widgets``` ```Right click on taskbar again -> Panel options -> Add widgets -> redshift```
1. set up firewall
    * run ```gufw```, turn ```status``` to on, and that's good enough
1. enable color in pacman: uncomment ```Color``` in ```/etc/pacman.conf```
1. enable fingerprint unlocking.  Install ```fprint```
    * enroll fingerprint using ```fprintd-enroll```
    * add the following: ```auth      sufficient pam_fprintd.so``` to the top of the auth lines in the following files
        * ```/etc/pam.d/system-local-login```
        * ```/etc/pam.d/lightdm```
1. Misc kde settings:
    * Look and Feel theme I use is "Breeze Dark", Desktop theme I use is "Ember", gtk theme is "Vertex Dark" (which is installed in one of the scripts)
    * Moka as my icon theme, humanity is my cursor theme
1. Run various scripts, useful ones include:
    * MirrorRank: Rank pacman mirrors by download speed
    * BetterFont: Installing / set up better looking fonts (similar to what infinality used to do)
    * GeneralPackages / AurPackages: Quickly install some useful packages
    * PrinterSetup: Install a bunch of printer drivers
    * QtUserGtkTheme: Mostly useful for gnome-based environments, makes Qt apps look better
    * LaptopSetup: Instal laptop-mode-tools and set it up