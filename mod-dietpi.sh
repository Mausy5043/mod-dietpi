#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# create persistent directories for storing stuff while the prep-script wipes stuff
mkdir -p /boot/.log
rm /boot/.log/* 2>/dev/null

{
  # set defaults
  BRANCH="dev"
  HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
  MACHINE="$(hostname | awk -F. '{print $1}')"
  PREP_SCRIPT=/tmp/prep_dietpi.sh
  SERVICE_DIR=/opt/mod-dietpi

  echo ""
  echo "**************************************************"
  # parse CLI parameters
  CLOPT=("$@")
  echo "Arguments passed to mod-dietpi.sh: ${CLOPT[@]}"
  echo ""
  while true; do
    case "$1" in
      -b | --branch )  BRANCH=$2; shift; shift ;;
      -m | --machine ) MACHINE="$2"; shift; shift ;;
      -s | --service ) SERVICE_DIR="$2"; shift; shift ;;
      -- ) shift; break ;;
      "" ) break ;;
      * ) echo "Ignoring unknown option: $1"; shift ;;
    esac
  done

  echo "Installing on ${MACHINE} using the ${BRANCH} branch."
  echo "**************************************************"
  echo ""
  echo "Intermediate storage will be set-up in ${SERVICE_DIR}"
  sleep 10

  # set-up a persistent storage if it doesn't exist yet.
  if [ ! -d "${SERVICE_DIR}" ]; then
    sudo mkdir -p "${SERVICE_DIR}/mod-dietpi"
  fi

  if [ -d "${HERE}/machines/${MACHINE}" ]; then
    echo "Preparing configuration..."
    # the repo may not have been cloned in a safe location
    # we copy the scripts and other files to the persistent storage
    cp -v "${HERE}/machines/Automation_Custom_PreScript.sh" "${SERVICE_DIR}"
    cp -v "${HERE}/machines/Automation_Custom_Script.sh" "${SERVICE_DIR}"
    cp -v "${HERE}/machines/${MACHINE}"/diet* "${SERVICE_DIR}"
    cp -v "${HERE}/machines/${MACHINE}/add-packages.sh" "${SERVICE_DIR}/mod-dietpi/"
    cp -v "${HERE}/machines/${MACHINE}/mod-files.sh" "${SERVICE_DIR}/mod-dietpi/"
    cp -rv "${HERE}/machines/${MACHINE}/config" "${SERVICE_DIR}/mod-dietpi/"
    echo ""
  fi

  if [ -f "${HERE}/machines/${MACHINE}/uninstall.sh" ]; then
    echo "Removing post-installed stuff..."
    source "${HERE}/machines/${MACHINE}/uninstall.sh"
  fi

  cd /tmp || exit 1
  if [ -f "${PREP_SCRIPT}" ]; then
    echo "Not downloading script as it already exists."
  else
    echo "Downloading script..."
    curl -sSfL "https://raw.githubusercontent.com/MichaIng/DietPi/${BRANCH}/PREP_SYSTEM_FOR_DIETPI.sh" > "${PREP_SCRIPT}"
    echo
    # modify the newly downloaded script
    if [ ! -f "${PREP_SCRIPT}" ]; then
      echo "Script not found..."
      exit 1
    else
      echo ""
      echo "Modifying script..."
      # no modifications needed (yet).
    fi
  fi

  # pre-set variables for non-interactive execution of $PREP_SCRIPT
  export GITBRANCH='master'
  export IMAGE_CREATOR='Mausy5043'
  export PREIMAGE_INFO='re_install'
  export HW_MODEL=0
  export WIFI_REQUIRED=1
  export DISTRO_TARGET=6
  echo ""
  echo "Running script..."
  bash "${PREP_SCRIPT}"

  echo ""
  echo "Post-script actions..."
  if [ -f "${SERVICE_DIR}/dietpi.txt" ]; then
    echo "Injecting custom configuration."
    # recover files from persistent storage
    cp -rv "${SERVICE_DIR}"/* /boot/ 2>/dev/null
  fi

  echo "Rebooting in 60 seconds."
  # prevent booting into a coma
  systemctl disable dietpi-fs_partition_resize
  echo ""; echo ""
} 2>&1 | tee /boot/.log/mod-dietpi.log

# sync the disks and let things settle down.
sync; sync
# start a fresh install
# NOTE: shutdown doesn't work here because dbus is crippled at this point!
sleep 60; reboot
