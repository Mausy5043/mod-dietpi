#!/bin/bash

# stop kimnaty and remove services etc.
if [ -d /home/pi/lektrix ]; then
  pushd "/home/pi/lektrix" || exit 0
    su -c "/home/pi/lektrix/lektrix --uninstall" pi
     # remove rclone's local mountpoints
    sudo rm -rv /srv/rmt
    sudo rm -rv /srv/drv
popd || exit 0
fi
