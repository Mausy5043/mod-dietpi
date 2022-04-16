#!/bin/bash

unstall(){
  if [ -d "${1}" ]; then
    . "${1}/uninstall.sh"
  fi
}

unstall /home/pi/kimnaty
unstall /home/pi/kamstrup
unstall /home/pi/kamstrupd
unstall /home/pi/upsdiagd
unstall /home/pi/aircon
