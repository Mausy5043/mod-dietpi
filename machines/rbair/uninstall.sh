#!/bin/bash

# stop kimnaty and remove services etc.
pushd "/home/pi/kimnaty" || exit 0
  su -c "/home/pi/kimnaty/kimnaty --uninstall" pi
  # remove rclone's local mountpoint
  sudo rm -rv /srv/rmt
popd || exit 0
