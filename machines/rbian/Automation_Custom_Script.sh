#!/bin/bash


{
  echo ""
  echo "****************************************"
  echo "*  DIETPI AUTOMATION CUSTOM POSTSCRIPT *"
  echo "****************************************"
  echo ""
  echo "$SHELL"
  echo ""

  # TODO: review these cmdline settings:
  # TODO: cmdline="dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 noatime loglevel=6 cgroup_enable=memory elevator=noop fsck.repair=yes"
  # TODO: noatime` added to reduce wear on SD-card
  # TODO: `loglevel=6` to increase logging during boot
  # TODO: `cgroup_enable=memory` added to enable notification of upcoming OOM events

  # TODO: why are systemd dervices complaining about the bus not being there?

  # TODO: revoke root-access via SSH
  # TODO: add user `pi` with sudo-rights and groups: "adm,users,video,dialout"

  # TODO: disable ipv6

  # TODO: check post-install.txt
  # TODO: install dotfiles
  # TODO: evaluate installation of raspboot or implement it here.
  # TODO: evaluate if DNSSEC needs to be switched off.

  # TODO: properly set-up locale as perl keeps complaining about it.
  # TODO:   timezone=Europe/Amsterdam
  # TODO:   locales="en_US.UTF-8"
  # TODO:   system_default_locale="en_US.UTF-8"

  # TODO: check if these are missing packages and if they are needed:
  # TODO: f2fs-tools nfs-common curl psmisc
  packages="apt-utils bash-completion bc file gettext less lsb-release lsof screen tree zip"

  # TODO: link python to python3 executable

  # TODO: install these missing python3 packages (will install all others)
  # TODO: pytz skyfield

  # DEBUG: find out more about the state of the machine at this point
  pstree -a
  echo
  systemctl --no-pager --plain list-unit-files
  echo
  systemctl status
  echo
  ip address

  echo ""
  echo "****************************************"
  echo "*   AUTOMATION CUSTOM POSTSCRIPT END   *"
  echo "****************************************"
  echo ""
} | tee /boot/.log/postscript.log
