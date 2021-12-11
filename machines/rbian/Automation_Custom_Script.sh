#!/bin/bash


{
  echo ""
  echo "****************************************"
  echo "*  DIETPI AUTOMATION CUSTOM POSTSCRIPT *"
  echo "****************************************"
  date  +"%Y.%m.%d %H:%M:%S"
  echo ""
  source /boot/dietpi.txt
  echo "Repairing locale..."
  # repair the locale to suppress errors during SSH-sessions like these:
  # perl: warning: Setting locale failed.
  # or
  # -bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8)
  /usr/sbin/update-locale LC_ALL="en_US.UTF-8"
  /usr/sbin/update-locale LANGUAGE="en_US:en"

  echo ""
  echo "Adding user pi..."
  # TODO: add user `pi` with sudo-rights and groups: "adm,users,video,dialout"
  # add new user `pi`
  # move user and group dietpi to UID=1010 & GID=1010
  usermod -u 1010 dietpi
  groupmod -g 1010 dietpi
  find / -group 1000 -exec chgrp -h dietpi {} \; 2>/dev/null
  find / -user 1000 -exec chown -h dietpi {} \; 2>/dev/null
  # add user:group pi
  useradd -m -s /bin/bash -u 1000 -G adm,audio,dialout,sudo,gpio,systemd-journal,users,video pi
  echo -n "pi:raspberry" | /usr/sbin/chpasswd
  echo ""
  echo "Setting up account for user pi..."
  mkdir -m 0700 -p "/home/pi/.ssh"
  touch /home/pi/.bin
  ln -s "/home/pi/.bin" "/home/pi/bin"
  mkdir -p /home/pi/.config
  touch /home/pi/.dircolors
  touch /home/pi/.rsync
  touch /home/pi/.screenrc
  # install dotfiles
  git clone -b main https://gitlab.com/mausy5043/dotfiles.git "/home/pi/dotfiles"
  chmod -R 0755 "/home/pi/dotfiles"
  su -c '/home/pi/dotfiles/install_pi.sh' pi
  rm /home/pi/.*bak

  # add new user `pi` to sudoers
  echo "pi ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/012_pi-nopasswd

  # let user pi take ownership of all files
  chown -R pi:pi /home/pi
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
  echo "Creating extra mountpoints..."
  mkdir -p /srv/config
  mkdir -p /srv/databases
  mkdir -p /srv/files
  echo "...and adding them to /etc/fstab..."
  {
    echo "rbfile.fritz.box:/srv/nfs/config     /srv/config     nfs4     nouser,atime,rw,dev,exec,suid,_netdev,x-systemd.automount,noauto  0   0"
    echo "rbfile.fritz.box:/srv/nfs/databases  /srv/databases  nfs4     nouser,atime,rw,dev,exec,suid,_netdev,x-systemd.automount,noauto  0   0"
    echo "rbfile.fritz.box:/srv/nfs/files      /srv/files      nfs4     nouser,atime,rw,dev,exec,suid,_netdev,x-systemd.automount,noauto  0   0"
  } >> /etc/fstab
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

  # TODO: check if these are missing packages and if they are needed:
  # TODO: f2fs-tools nfs-common curl psmisc
  packages="apt-utils bash-completion bc file gettext less lsb-release lsof screen tree zip"
  # shellcheck disable=SC2086
  apt-get -yq install ${packages}

  # TODO: link python to python3 executable

  # TODO: install these missing python3 packages (will install all others)
  # TODO: pytz skyfield

  # DEBUG: find out more about the state of the machine at this point
  echo
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
  # reboot to close the root console
  shutdown -r +2
} 2>&1 | tee /boot/.log/install_2_script.log

# sync the disks and let things settle down.
sync; sync
