#!/bin/bash

# stop upsdiagd and remove services etc.
/home/pi/upsdiagd/uninstall.sh

# stop bups and remove services etc.
pushd "/home/pi/bups" || exit 0
  ./bups --uninstall
popd || exit 0
