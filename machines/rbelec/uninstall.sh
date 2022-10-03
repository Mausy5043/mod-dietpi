#!/bin/bash

# stop kimnaty and remove services etc.
pushd "/home/pi/lektrix" || exit 0
  ./lektrix --uninstall
popd || exit 0
