# my-baremetal

## install before `makepkg`

* `my-base-devel-meta`
  * `makepkg` needs devel to work
* `systemd-boot-pacman-hook`
* `reflector-hooks-services`
* `my-gpu`

### From AUR

* `systemd-boot-pacman-hook`

## Post-Install

* Enable `systemd` units for:
  * `cleanup-journald`
  * `irqbalance`
  * `networkmanager`
  * `reflector-hooks-services`
  * `rng-tools`
  * `ufw`
  * `systemd-swap` if you want
* Enable outside of `systemd`
  * `ufw`
* Set config for `reflector-hooks-service`
