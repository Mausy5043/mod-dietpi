#!/usr/bin/env bash

# set defaults
DEVICE="SD-card"
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
MACHINE="$(hostname | awk -F. '{print $1}')"

echo ""
echo "**************************************************"
# parse CLI parameters
CLOPT=("$@")
echo "Arguments passed to mod-dietpi.sh: ${CLOPT[@]}"
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
  echo "Use: --device <device>"
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
  cp -v "${HERE}/machines/${MACHINE}/add-packages.sh" "${DEVICE}/mod-dietpi/"
  cp -v "${HERE}/machines/${MACHINE}/mod-files.sh" "${DEVICE}/mod-dietpi/"
  cp -rv "${HERE}/machines/${MACHINE}/config" "${DEVICE}/mod-dietpi/"
  echo ""
fi

echo "Ready"
echo
