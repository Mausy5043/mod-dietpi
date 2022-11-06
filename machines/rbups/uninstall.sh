#!/bin/bash

# stop upsdiagd and remove services etc.
if [ -d /home/pi/upsdiagd ]; then
  /home/pi/upsdiagd/uninstall.sh
fi

# stop bups and remove services etc.
if [ -d /home/pi/bups ]; then
  pushd "/home/pi/bups" || exit 0
    ./bups --uninstall
  popd || exit 0
fi
