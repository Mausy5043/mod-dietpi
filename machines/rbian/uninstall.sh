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

unstal2 kimnaty
unstall /home/pi/kamstrup
unstall /home/pi/kamstrupd
unstall /home/pi/upsdiagd
unstall /home/pi/aircon

unstal2 lektrix
