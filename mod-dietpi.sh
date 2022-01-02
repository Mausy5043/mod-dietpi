#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# create persistent directories for storing stuff while the prep-script wipes stuff
mkdir -p /boot/.bin
rm /boot/.bin/* 2>/dev/null
mkdir -p /boot/.log
rm /boot/.log/* 2>/dev/null

{
  # set defaults
  BRANCH="dev"
  HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
  MACHINE="$(hostname | awk -F. '{print $1}')"
  PREP_SCRIPT=/tmp/prep_dietpi.sh

  echo ""
  echo "**************************************************"
  echo "Arguments passed to mod-ua.sh: ${CLOPT[@]}"
  echo ""
  # parse CLI parameters
  CLOPT=("$@")
  while true; do
    case "$1" in
      -b | --branch ) BRANCH=$2; shift; shift ;;
      -m | --machine ) MACHINE="$2"; shift; shift ;;
      -- ) shift; break ;;
      "" ) break ;;
      * ) echo "Ignoring unknown option: $1"; shift ;;
    esac
  done

  echo "Installing on ${MACHINE} using the ${BRANCH} branch."
  echo "**************************************************"
  echo ""
  sleep 10

  if [ -d "${HERE}/machines/${MACHINE}" ]; then
    echo "Preparing configuration..."
    # the repo may not have been cloned in a safe location
    # we copy the scripts and other files to the persistent storage
    cp -v "${HERE}/machines"/*.sh /boot/.bin/
    cp -rv "${HERE}/machines/${MACHINE}"/* /boot/.bin/  || exit 1
    echo ""
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
  export WIFI_REQUIRED=0
  export DISTRO_TARGET=6
  echo ""
  echo "Running script..."
  bash "${PREP_SCRIPT}"

  echo ""
  echo "Post-script actions..."
  if [ -f /boot/.bin/dietpi.txt ]; then
    echo "Injecting custom configuration."
    # recover files from persistent storage
    # not using `-r` will cause an error so we'll divert that
    cp -v /boot/.bin/* /boot/ 2>/dev/null
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
