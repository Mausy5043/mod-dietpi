#!/bin/bash

# stop aircon and remove services etc.
pushd "/home/pi/aircon" || exit 0
  ./uninstall.sh
popd || exit 0

sudo rm  /etc/cron.d/98no-eth0
