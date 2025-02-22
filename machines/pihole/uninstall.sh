#!/bin/bash

unstall(){
  if [ -d "${1}" ]; then
    su -c "${1}/uninstall.sh" pi
  fi
}

unstal2(){
  if [ -d "/home/pi/${1}" ]; then
    su -c "/home/pi/${1}/${1} --uninstall" pi
  fi
}

# remove rclone's local mountpoints
sudo rm -rv /srv/rmt
sudo rm -rv /srv/drv
