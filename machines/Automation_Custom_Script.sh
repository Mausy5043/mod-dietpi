#!/bin/bash

USER=pi
USER_ID=1000
DIETPI_ID=1010

SERVICE_DIR=/boot/mod-dietpi
REMOTE_DIR=""
USB_DEV=""
USB_DIR=""

declare -a apt_packages=(
  "apt-utils"
  "bash-completion"
  "build-essential"
  "bc"
  "file"
  "git"
  "gettext"
  "less"
  "lsb-release"
  "lsof"
  "man"
  "netbase"
  "nfs-common"
  "python3"
  "python3-pip"
  "python3-dev"
  "screen"
  "tree"
  "zip")
  # "systemd-journal-remote"
  # "f2fs-tools"
# See if packages are installed and install them.
install_apt_package()
{
  package=${1}
  echo "*********************************************************"
  echo "* Requesting ${package}"
  status=$(dpkg -l | awk '{print $2}' | grep -c -e "^${package}$")
  if [ "${status}" -eq 0 ]; then
    echo "* Installing ${package}"
    echo "*********************************************************"
    apt-get -yqV install "${package}"
  else
    echo "* Already installed !!!"
    echo "*********************************************************"
  fi
}

# Install these python packages by default
declare -a py_packages=("pytz" "skyfield")
# See if packages are installed and install them.
install_py_package()
{
  package=${1}
  echo "********************************************************PIP*"
  echo "* Requesting ${package}"
  echo ""
  su -c "python3 -m pip install ${package}" "${USER}"
  echo ""
}

claim_path()
{
  path_to_claim="${1}"
  if [ ! -e "${path_to_claim}" ]; then
    mkdir -p "${path_to_claim}"
    chown -R "${USER_ID}:users" "${path_to_claim}"
    echo "${path_to_claim} created."
  else
    echo "${path_to_claim} already exists. No action taken!"
  fi
}

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
    echo "###### Added by Automation_Custom_Script.sh"
    echo "::1             localhost ip6-localhost ip6-loopback"
    echo "fe00::0         ip6-localnet"
    echo "ff00::0         ip6-mcastprefix"
    echo "ff02::1         ip6-allnodes"
    echo "ff02::2         ip6-allrouters"
    echo "###### Added by Automation_Custom_Script.sh"
  }>> /etc/hosts

  # is rclone available?
  if command -v rclone; then
    echo "Detected rclone command..."
    REMOTE_DIR="/srv/rmt"
    if [ ! -d "${REMOTE_DIR}" ]; then
      claim_path "${REMOTE_DIR}"
    fi
  fi

  echo ""
  echo "Creating extra mountpoints..."
  claim_path /srv/config
  claim_path /srv/databases
  claim_path /srv/files

  # is USB-drive attached?
  if [ -e /dev/sda1 ]; then
    echo "Detected USB-drive..."
    USB_DEV="/dev/sda1"
    USB_DIR="/srv/usb"
    if [ ! -d "${USB_DIR}" ]; then
      # DietPi will have detected it too. Remove the entry in /etc/fstab
      sed -i '/ \/srv\/usb /d' /etc/fstab
      claim_path "${USB_DIR}"
    else
      echo "Mountpoint for USB already exists."
    fi
  fi

  echo "...and adding them to /etc/fstab..."
  {
    echo "rbfile.fritz.box:/srv/nfs/config     /srv/config     nfs4     nouser,atime,rw,dev,exec,suid,_netdev,x-systemd.automount,noauto  0   0"
    echo "rbfile.fritz.box:/srv/nfs/databases  /srv/databases  nfs4     nouser,atime,rw,dev,exec,suid,_netdev,x-systemd.automount,noauto  0   0"
    echo "rbfile.fritz.box:/srv/nfs/files      /srv/files      nfs4     nouser,atime,rw,dev,exec,suid,_netdev,x-systemd.automount,noauto  0   0"
    echo "${USB_DEV}                            ${USB_DIR}        ext4     noatime,lazytime,rw                                               0   2"
  } >> /etc/fstab


  if [ -e "${USB_DEV}" ]; then
    echo "Mounting USB-drive..."
    mount "${USB_DIR}"
  fi

  echo ""
  date  +"%Y.%m.%d %H:%M:%S"
  echo ""
  echo "Installing default packages..."
  for PKG in "${apt_packages[@]}"; do
    install_apt_package "${PKG}"
  done

  # need to have nfs-common installed before doing these mounts:
  echo ""
  echo "Mounting /srv/config..."
  mount /srv/config
  echo "Mounting /srv/databases..."
  mount /srv/databases
  echo "Mounting /srv/files..."
  mount /srv/files

  echo ""
  date  +"%Y.%m.%d %H:%M:%S"
  echo ""
  # link python to python3 executable
  if [ ! -e /usr/bin/python ]; then
    ln -s /usr/bin/python3 /usr/bin/python
  fi

  # install my own banner
  if [ -f /boot/dietpi-banner ]; then
    echo ""
    echo "Install custom banner..."
    mv -v /boot/dietpi-banner /boot/dietpi/.dietpi-banner
  fi
  if [ -f /boot/dietpi-banner_custom ]; then
    mv -v /boot/dietpi-banner_custom /boot/dietpi/.dietpi-banner_custom
  fi

  echo ""
  echo "Adding user ${USER}..."
  # move user:group dietpi to UID=1010 & GID=1010
  usermod -u "${DIETPI_ID}" dietpi
  groupmod -g "${DIETPI_ID}" dietpi
  find / ! -path "/home/pi*" ! -path "/srv/*" ! -path "/proc/*" ! -path "/dev/*" -group "${USER_ID}" -exec chgrp -h dietpi {} \; 2>/dev/null
  find / ! -path "/home/pi*" ! -path "/srv/*" ! -path "/proc/*" ! -path "/dev/*" -user  "${USER_ID}" -exec chown -h dietpi {} \; 2>/dev/null

  # Check if user exists
  if id -u "${USER}" > /dev/null 2>&1; then
    deluser "${USER}"
    delgroup "${USER}"
  fi

  # (re-)add user:group "${USER}"
  useradd -m -s /bin/bash -u "${USER_ID}" -G adm,audio,dialout,sudo,gpio,systemd-journal,users,video "${USER}"
  # first set the default passwd...
  echo -n "${USER}:raspberry" | /usr/sbin/chpasswd
  # ...then re-set the password in case it is defined
  source "/srv/config/.${USER}.passwd"
  # FIXME:  /srv/config/.pi.passwd: line 1: raspberry: command not found
  # TODO:   echo -n "${USER}:${USRPASSWD}" | /usr/sbin/chpasswd

  # add new user `${USER}` to sudoers
  echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/012_${USER}-nopasswd

  echo ""
  echo "Revoking root's SSH-access for security reasons..."
  sed -i "s/^PermitRootLogin/#&/" /etc/ssh/sshd_config

  # TODO: review these cmdline settings:
  # TODO: cmdline="dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 noatime loglevel=6 cgroup_enable=memory elevator=noop fsck.repair=yes"
  # TODO: noatime` added to reduce wear on SD-card
  # TODO: `loglevel=6` to increase logging during boot
  # TODO: `cgroup_enable=memory` added to enable notification of upcoming OOM events

  # TODO: why are systemd devices complaining about the bus not being there?

  echo ""
  echo "Setting up account for user ${USER}..."
  # shellcheck disable=SC2174
  mkdir -m 0700 -p "/home/${USER}/.ssh"
  # Fetch stuff from the file-server's config mount
  cp -v /srv/config/.mailrc /home/${USER}/
  chmod 0600 /home/${USER}/.mailrc
  cp -v /srv/config/.netrc /home/${USER}/
  chmod 0600 /home/${USER}/.netrc


  # set git globals
  su -c "git config --global pull.rebase false" ${USER}
  su -c "git config --global core.fileMode false" ${USER}

  echo ""
  echo "Installing default Python packages..."
  # su -c "python3 -m pip install ${PYpackages}" ${USER}
  for PKG in "${py_packages[@]}"; do
    install_py_package "${PKG}"
  done

  echo
  date  +"%Y.%m.%d %H:%M:%S"
  # install dotfiles
  touch /home/${USER}/.bin
  ln -s "/home/${USER}/.bin" "/home/${USER}/bin"
  claim_path "/home/${USER}/.config"
  touch /home/${USER}/.dircolors
  touch /home/${USER}/.rsync
  touch /home/${USER}/.screenrc

  # Fetch stuff from the USB-drive
  if [ -d "${USB_DIR}" ]; then
    claim_path "/home/${USER}/.config/rclone"
    cp -vR ${USB_DIR}/_config/rclone /home/${USER}/.config/
  else
    echo "USB-drive not mounted!"
  fi

  git clone -b main https://gitlab.com/mausy5043/dotfiles.git "/home/${USER}/dotfiles"
  chmod -R 0755 "/home/${USER}/dotfiles"
  su -c "/home/${USER}/dotfiles/install_pi.sh" ${USER}
  rm /home/${USER}/.*bak

  # let user ${USER} take ownership of all files
  chown -R ${USER}:${USER} /home/${USER}

  # Install a custom script for reboot actions
  mkdir -p /var/lib/dietpi/dietpi-autostart/
  cat << 'EOF' >> /var/lib/dietpi/dietpi-autostart/custom.sh
#!/bin/bash

tmpfile=$(mktemp /tmp/route.XXXXXX)
ip -f inet route > ${tmpfile}
ip -f inet6 route >> ${tmpfile}
chmod +r ${tmpfile}
su -c "python3 /home/pi/bin/pymail.py -f ${tmpfile} -s '$(hostname) was booted on $(date)'" pi
rm ${tmpfile}

exit 0
EOF

  echo
  date  +"%Y.%m.%d %H:%M:%S"

  # server-specific modifications
  echo ""
  echo "Post-post-install options..."
  echo "Additional packages for server-specific duties..."
  if [ -e "${SERVICE_DIR}/add-packages.sh" ]; then
    source "${SERVICE_DIR}/add-packages.sh"
  fi

  # Install server specific configuration files
  echo
  echo "Copy configuration files for server-specific duties..."
  for f in "${SERVICE_DIR}"/config/*; do
    g=$(basename "${f}" | sed 's/@/\//g')
    # path must already exist for this to work:
    cp -v "${f}" "/${g}"
  done

  # Modify existing server specific configuration files
  echo
  echo "Modify installation for server-specific duties..."
  if [ -e "${SERVICE_DIR}/mod-files.sh" ]; then
    source "${SERVICE_DIR}/mod-files.sh"
  fi
  echo
  echo "Fetching databases..."
  su -c "rclone -v copy remote:raspi/_databases /srv/rmt/_databases" "${USER}"
  # servers update regularly using:
  # rclone sync /srv/rmt/_databases remote:raspi/_databases

  # log the state of the machine at this point
  echo
  pstree -a
  echo
  systemctl --no-pager --plain list-unit-files
  echo
  ip address

  sync;sync
  umount /srv/config
  umount /srv/databases
  umount /srv/files
  if [ -e "${USB_DEV}" ]; then
    umount "${USB_DIR}"
  fi

  echo ""
  echo "****************************************"
  echo "*   AUTOMATION CUSTOM POSTSCRIPT END   *"
  echo "****************************************"
  echo ""
  echo
  date  +"%Y.%m.%d %H:%M:%S"
  # reboot to close the root console
  shutdown -r +5
} 2>&1 | tee "${SERVICE_DIR}/install_2_script.log"

# sync the disks and let things settle down.
sync; sync
