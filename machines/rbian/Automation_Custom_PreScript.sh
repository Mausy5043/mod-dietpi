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
  echo "$SHELL"
  echo ""

  # DEBUG: find out more about the state of the machine at this point
  pstree -a
  echo
  systemctl --no-pager --plain list-unit-files
  echo
  systemctl status

  echo ""
  echo "***************************************"
  echo "*  AUTOMATION CUSTOM PRESCRIPT ENDS   *"
  echo "***************************************"
  echo ""
  echo
} | tee /boot/.log/prescript.log
