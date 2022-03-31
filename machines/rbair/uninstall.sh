#!/bin/bash

# stop kimnaty and remove services etc.
pushd "/home/pi/kimnaty" || exit 0
  ./uninstall.sh
popd || exit 0
