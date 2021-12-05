#!/usr/bin/env bash
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
  systemd-analyze --no-pager dump
  echo
  systemctl --no-pager --plain list-units-files
  echo
  systemctl status

  echo ""
  echo "***************************************"
  echo "*  AUTOMATION CUSTOM PRESCRIPT ENDS   *"
  echo "***************************************"
  echo ""
  echo
} | tee /boot/prescript.log
