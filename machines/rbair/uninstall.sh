#!/bin/bash

# stop kimnaty and remove services etc.
pushd "/home/pi/kimnaty" || exit 0
  ./kimnaty --uninstall
popd || exit 0
