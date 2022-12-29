#!/bin/bash

# stop kimnaty and remove services etc.
pushd "/home/pi/lektrix" || exit 0
  ./lektrix --uninstall
   # remove rclone's local mountpoint
  sudo rm -rv /srv/rmt
popd || exit 0
