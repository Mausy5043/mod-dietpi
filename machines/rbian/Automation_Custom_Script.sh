#!/bin/bash
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

  pstree -a
  # network up?
  ip address

  echo ""
  echo "****************************************"
  echo "*   AUTOMATION CUSTOM POSTSCRIPT END   *"
  echo "****************************************"
  echo ""
} | tee /boot/postscript.log
