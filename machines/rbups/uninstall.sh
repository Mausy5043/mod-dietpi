#!/bin/bash

# stop aircon and remove services etc.
pushd "/home/pi/upsdiagd"
  ./uninstall.sh
popd
