#!/bin/bash

# create a persistent directory for storing logs
mkdir -p /boot/.log

{
  echo ""
  echo "****************************************"
  echo "*  DIETPI AUTOMATION CUSTOM POSTSCRIPT *"
  echo "****************************************"
  echo ""
  echo "$SHELL"
  echo ""

  # missing packages:
  # file
  # tree
  # apt-utils
  # bc
  # lsof
  # screen
  # less

  # link python to python3 executable
  # missing python3 packages (will install all others)
  # pytz
  # skyfield

  # DEBUG: find out more about the state of the machine at this point
  pstree -a
  echo
  systemctl --no-pager --plain list-units-files
  echo
  systemctl status
  # network up?
  ip address

  echo ""
  echo "****************************************"
  echo "*   AUTOMATION CUSTOM POSTSCRIPT END   *"
  echo "****************************************"
  echo ""
} | tee /boot/.log/postscript.log
