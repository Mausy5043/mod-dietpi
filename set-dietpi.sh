#!/usr/bin/env bash

# this script copies the custom files required for `machine` to an SD-card mounted on `device`

# set defaults
DEVICE="set-dietpi Destination"
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
MACHINE="$(hostname | awk -F. '{print $1}')"

echo ""
echo "**************************************************"
# parse CLI parameters
CLOPT=("$@")
echo "Arguments passed to set-dietpi.sh: ${CLOPT[@]}"
echo ""
while true; do
  case "$1" in
    -d | --device )  DEVICE="${2}"; shift; shift ;;
    -m | --machine ) MACHINE="$2"; shift; shift ;;
    -- ) shift; break ;;
    "" ) break ;;
    * ) echo "Ignoring unknown option: $1"; shift ;;
  esac
done

if [ ! -d "${DEVICE}" ]; then
  echo "${DEVICE} not defined."
  echo "Usage:"
  echo "set-dietpi.sh --machine <name> --device <dir name of mountpoint>"
  exit 1
fi

echo "Setting up ${MACHINE} on ${DEVICE} "
echo "**************************************************"
echo ""
sleep 10

mkdir -p "${DEVICE}/mod-dietpi"

if [ -d "${HERE}/machines/${MACHINE}" ]; then
  echo "Preparing configuration..."
  # the repo may not have been cloned in a safe location
  # we copy the scripts and other files to the persistent storage
  cp -v "${HERE}/machines/Automation_Custom_PreScript.sh" "${DEVICE}"
  cp -v "${HERE}/machines/Automation_Custom_Script.sh" "${DEVICE}"
  cp -v "${HERE}/machines/${MACHINE}"/diet* "${DEVICE}"
  cp -v "${HERE}/../dietpi-wifi.txt" "${DEVICE}"
  cp -v "${HERE}/machines/${MACHINE}/add-packages.sh" "${DEVICE}/mod-dietpi/"
  cp -v "${HERE}/machines/${MACHINE}/mod-files.sh" "${DEVICE}/mod-dietpi/"
  cp -rv "${HERE}/machines/${MACHINE}/config" "${DEVICE}/mod-dietpi/"
  cp -rv "${HERE}/machines/${MACHINE}/config.txt" "${DEVICE}/mod-dietpi/"
  echo ""
else
  echo "Machine ${MACHINE} not defined."
fi

echo "Ready"
echo
