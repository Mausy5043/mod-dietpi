#!/usr/bin/env bash

# make sure a persistent directory for storing logs and binaries exists
mkdir -p /boot/.log
SERVICE_DIR=/boot/mod-dietpi
{
  echo ""
  echo "**************************************"
  echo "*  START AUTOMATION_CUSTOM_PRESCRIPT *"
  echo "**************************************"
  echo ""
  echo
  date  +"%Y.%m.%d %H:%M:%S"

  # DEBUG: find out more about the state of the machine at this point
  dmesg -HkuPxe

  # Only include actions here that cannot wait until the Automation_Custom_script.sh is executed.
  # Some changes may be overridden by the DietPi scripts!

  echo
  date  +"%Y.%m.%d %H:%M:%S"
  echo ""
  echo "***************************************"
  echo "*  AUTOMATION_CUSTOM_PRESCRIPT ENDS   *"
  echo "***************************************"
  echo ""
} 2>&1 | tee "${SERVICE_DIR}/install_1_script.log"

sync; sync
