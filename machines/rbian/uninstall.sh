#!/bin/bash

unstall(){
  if [ -d "${1}" ]; then
    . "${1}/uninstall.sh"
  fi
}

unstal2(){
  if [ -d "/home/pi/${1}" ]; then
    . "/home/pi/${1}/${1}" --uninstall
  fi
}
# legacy
unstall /home/pi/kamstrup
unstall /home/pi/kamstrupd
unstall /home/pi/upsdiagd
unstall /home/pi/aircon

unstal2 kimnaty
unstal2 lektrix
unstal2 bups

# remove rclone's local mountpoint
sudo rm -rv /srv/rmt
