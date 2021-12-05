#!/usr/bin/env bash

# create a persistent directory for storing logs
mkdir -p /boot/.log
mkdir -p /boot/.bin

{
  if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root"
    exit 1
  fi

  CLOPT=("$@")
  BRANCH="dev"
  MACHINE="$(hostname | awk -F. '{print $1}')"
  HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
  PREP_SCRIPT=/tmp/prep_dietpi.sh

  echo ""
  echo "**************************************************"
  echo "Arguments passed to mod-ua.sh: ${CLOPT[@]}"
  echo ""

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
    echo "Preparing configuration...-"
    # the repo may not have been cloned in a safe location
    # copy the scripts to the persistent storage
    cp -v "${HERE}/machines/${MACHINE}/*" /boot/.bin/
  fi

  cd /tmp
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
    cp -v /boot/.bin/* /boot/
  fi

  echo "Rebooting in 60 seconds."
  sleep 60
} | tee /boot/.log/mod-dietpi.log

reboot
