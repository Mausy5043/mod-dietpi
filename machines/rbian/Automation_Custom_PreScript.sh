#!/usr/bin/env bash

# make sure a persistent directory for storing logs and binaries exists
mkdir -p /boot/.log
mkdir -p /boot/.bin

{
  echo ""
  echo "***************************************"
  echo "*  DIETPI AUTOMATION CUSTOM PRESCRIPT *"
  echo "***************************************"
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
  usermod -l pi dietpi
  # reassign groups
  groupmod -n pi dietpi
  # rename home directory
  back=$(pwd)
  cd /home/dietpi
    usermod -d /home/pi -m pi
  cd "$back"

  # add new user `pi` to sudoers
  echo "pi ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/012_pi-nopasswd

  # TODO: revoke root-access via SSH
  echo ""
  echo "Revoking root's SSH-access for security reasons..."
  #sed -i "s/^PermitRootLogin/#&/" /etc/ssh/sshd_config

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
  }>> /rootfs/etc/hosts

  # DEBUG: find out more about the state of the machine at this point
  dmesg -HkuPxe

  echo ""
  echo "***************************************"
  echo "*  AUTOMATION CUSTOM PRESCRIPT ENDS   *"
  echo "***************************************"
  echo ""
  echo
} | tee /boot/.log/prescript.log

sync; sync
