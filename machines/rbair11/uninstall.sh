#!/bin/bash

# stop aircon and remove services etc.
pushd "/home/pi/aircon"
  ./uninstall.sh
popd
