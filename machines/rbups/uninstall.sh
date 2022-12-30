#!/bin/bash

# stop upsdiagd and remove services etc.
if [ -d /home/pi/upsdiagd ]; then
  su -c "/home/pi/upsdiagd/uninstall.sh" pi
fi

# stop bups and remove services etc.
if [ -d /home/pi/bups ]; then
  pushd "/home/pi/bups" || exit 0
    su -c "/home/pi/bups/bups --uninstall" pi
    # remove rclone's local mountpoint
    sudo rm -rv /srv/rmt
  popd || exit 0
fi
