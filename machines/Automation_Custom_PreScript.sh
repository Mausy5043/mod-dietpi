#!/usr/bin/env bash

# make sure a persistent directory for storing logs and binaries exists
mkdir -p /boot/.log
mkdir -p /boot/.bin

{
  echo ""
  echo "***************************************"
  echo "*  DIETPI AUTOMATION CUSTOM PRESCRIPT *"
  echo "***************************************"
  echo ""
  echo
  date  +"%Y.%m.%d %H:%M:%S"

  # DEBUG: find out more about the state of the machine at this point
  dmesg -HkuPxe

  # Only include actions here that cannot wait until the Automation_Custom_script.sh is executed.
  # Some changes may be overridden by the DietPi scripts!

  echo ""
  echo "***************************************"
  echo "*  AUTOMATION CUSTOM PRESCRIPT ENDS   *"
  echo "***************************************"
  echo ""
  echo
  date  +"%Y.%m.%d %H:%M:%S"
  echo
} 2>&1 | tee /boot/.log/install_1_script.log

sync; sync
