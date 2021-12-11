#!/bin/bash


{
  echo ""
  echo "****************************************"
  echo "*  DIETPI AUTOMATION CUSTOM POSTSCRIPT *"
  echo "****************************************"
  date  +"%Y.%m.%d %H:%M:%S"
  echo ""

  echo "Repairing locale..."
  # repair the locale to suppress errors during SSH-sessions like these:
  # perl: warning: Setting locale failed.
  # or
  # -bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8)
  /usr/sbin/update-locale LC_ALL="en_US.UTF-8"
  /usr/sbin/update-locale LANGUAGE="en_US:en"

  echo ""
  echo "Replacing user dietpi by user pi..."
  # TODO: add user `pi` with sudo-rights and groups: "adm,users,video,dialout"
  # add new user `pi`
  # rename user
  userdel -Z -r dietpi
  useradd -m -u 1000 -g 1000 -G adm,audio,dialout,sudo,gpio,systemd-journal,users,video pi

  # add new user `pi` to sudoers
  echo "pi ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/012_pi-nopasswd

  # TODO: revoke root-access via SSH
  echo ""
  echo "Revoking root's SSH-access for security reasons..."
  # FIXME: replace space by #
  sed -i "s/^PermitRootLogin/ &/" /etc/ssh/sshd_config

  echo ""
  echo "Updating /etc/hosts file..."
  {
    echo "###### Added by Automation_Custom_PreScript.sh"
    echo "::1             localhost ip6-localhost ip6-loopback"
    echo "fe00::0         ip6-localnet"
    echo "ff00::0         ip6-mcastprefix"
    echo "ff02::1         ip6-allnodes"
    echo "ff02::2         ip6-allrouters"
    echo "###### Added by Automation_Custom_PreScript.sh"
  }>> /etc/hosts

  echo ""

  # TODO: review these cmdline settings:
  # TODO: cmdline="dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 noatime loglevel=6 cgroup_enable=memory elevator=noop fsck.repair=yes"
  # TODO: noatime` added to reduce wear on SD-card
  # TODO: `loglevel=6` to increase logging during boot
  # TODO: `cgroup_enable=memory` added to enable notification of upcoming OOM events

  # TODO: why are systemd devices complaining about the bus not being there?

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
  ip address

  echo ""
  echo "****************************************"
  echo "*   AUTOMATION CUSTOM POSTSCRIPT END   *"
  echo "****************************************"
  echo ""
} | tee /boot/.log/postscript.log
