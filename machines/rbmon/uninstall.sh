#!/bin/bash

# stop kimnaty and remove services etc.
if [ -d /home/pi/kimnaty ]; then
  pushd "/home/pi/kimnaty" || exit 0
    su -c "/home/pi/kimnaty/kimnaty --uninstall" pi
  popd || exit 0
fi

# stop lektrix and remove services etc.
if [ -d /home/pi/lektrix ]; then
  pushd "/home/pi/lektrix" || exit 0
    su -c "/home/pi/lektrix/lektrix --uninstall" pi
popd || exit 0
fi

# stop wizwtr and remove services etc.
if [ -d /home/pi/wizwtr ]; then
  pushd "/home/pi/wizwtr" || exit 0
    su -c "/home/pi/wizwtr/wizwtr --uninstall" pi
popd || exit 0
fi

if [ -d /srv/rmt ]; then
  sudo rm -rv /srv/rmt
fi

if [ -d /srv/drv ]; then
  sudo rm -rv /srv/drv
fi
