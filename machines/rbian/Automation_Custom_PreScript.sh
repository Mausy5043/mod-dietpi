#!/usr/bin/env bash

# create a persistent directory for storing logs
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
  systemctl --no-pager --plain list-units-files
  echo
  systemctl status
  # network up?
  ip address

  echo ""
  echo "***************************************"
  echo "*  AUTOMATION CUSTOM PRESCRIPT ENDS   *"
  echo "***************************************"
  echo ""
  echo
} | tee /boot/.log/prescript.log
