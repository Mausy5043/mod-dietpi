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

  # DEBUG: find out more about the state of the machine at this point
  dmesg -HkuPxe

  echo ""
  echo "***************************************"
  echo "*  AUTOMATION CUSTOM PRESCRIPT ENDS   *"
  echo "***************************************"
  echo ""
  echo
} 2>&1 | tee /boot/.log/install_1_script.log

sync; sync
