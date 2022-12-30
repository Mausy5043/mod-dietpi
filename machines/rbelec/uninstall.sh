#!/bin/bash

# stop kimnaty and remove services etc.
pushd "/home/pi/lektrix" || exit 0
  su -c "/home/pi/lektrix/lektrix --uninstall" pi
   # remove rclone's local mountpoint
  sudo rm -rv /srv/rmt
popd || exit 0
