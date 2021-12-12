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
  echo "Mounting /srv/config"
  mount /srv/config

  echo ""
  echo "Adding user pi..."
  # move user:group dietpi to UID=1010 & GID=1010
  usermod -u 1010 dietpi
  groupmod -g 1010 dietpi
  find / -group 1000 -exec chgrp -h dietpi {} \; 2>/dev/null
  find / -user 1000 -exec chown -h dietpi {} \; 2>/dev/null
  # add user:group pi
  useradd -m -s /bin/bash -u 1000 -G adm,audio,dialout,sudo,gpio,systemd-journal,users,video pi
  # set default passwd
  echo -n "pi:raspberry" | /usr/sbin/chpasswd
  # add new user `pi` to sudoers
  echo "pi ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/012_pi-nopasswd

  echo ""
  echo "Revoking root's SSH-access for security reasons..."
  sed -i "s/^PermitRootLogin/#&/" /etc/ssh/sshd_config

  # TODO: review these cmdline settings:
  # TODO: cmdline="dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 noatime loglevel=6 cgroup_enable=memory elevator=noop fsck.repair=yes"
  # TODO: noatime` added to reduce wear on SD-card
  # TODO: `loglevel=6` to increase logging during boot
  # TODO: `cgroup_enable=memory` added to enable notification of upcoming OOM events

  # TODO: why are systemd devices complaining about the bus not being there?

  # TODO: disable ipv6

  # TODO: check post-install.txt
  # TODO: evaluate installation of raspboot or implement it here.
  # TODO: evaluate if DNSSEC needs to be switched off.

  echo ""
  echo "Setting up account for user pi..."
  # shellcheck disable=SC2174
  mkdir -m 0700 -p "/home/pi/.ssh"
  # Fetch .mailrc
  cp -v /srv/config/.mailrc /home/pi/
  chmod 0600 /home/pi/.mailrc
  # install dotfiles
  git clone -b main https://gitlab.com/mausy5043/dotfiles.git "/home/pi/dotfiles"
  touch /home/pi/.bin
  ln -s "/home/pi/.bin" "/home/pi/bin"
  mkdir -p /home/pi/.config
  touch /home/pi/.dircolors
  touch /home/pi/.rsync
  touch /home/pi/.screenrc
  # let user pi take ownership of all files
  chown -R pi:pi /home/pi
  chmod -R 0755 "/home/pi/dotfiles"
  su -c '/home/pi/dotfiles/install_pi.sh' pi
  rm /home/pi/.*bak

  # not yet installing f2fs-tools
  packages="apt-utils bash-completion bc file gettext less lsb-release lsof screen tree zip"
  # shellcheck disable=SC2086
  apt-get -yq install ${packages}
  # link python to python3 executable
  sudo ln -s /usr/bin/python3 /usr/bin/python

  # install some python3 packages for user pi
  pypackages="pytz skyfield"
  su -c "python3 -m pip install ${pypackages}" pi

  # Install additional git repos here
  #
  #
  #

  # Install a custom script for reboot actions
  cat << 'EOF' >> /var/lib/dietpi/dietpi-autostart/custom.sh
#!/bin/bash
echo "custom autostart test"
# TODO: do something useful here
su -c 'python3 /home/pi/bin/pymail.py --subject "$(hostname) was booted on $(date)"' pi
ip address
exit 0
EOF


  umount /srv/config
  # log the state of the machine at this point
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
