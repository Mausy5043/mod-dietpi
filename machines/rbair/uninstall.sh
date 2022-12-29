#!/bin/bash

# stop kimnaty and remove services etc.
pushd "/home/pi/kimnaty" || exit 0
  ./kimnaty --uninstall
  # remove rclone's local mountpoint
  sudo rm -rv /srv/rmt
popd || exit 0
