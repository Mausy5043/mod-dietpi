#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
PREP_SCRIPT=/tmp/prep_dietpi.sh
if [ "$#" -eq 1 ]; then
  BRANCH=$1
else
  BRANCH="dev"
fi
echo "Using the ${BRANCH} script"

pushd /tmp || exit 1
  if [ -f "${PREP_SCRIPT}" ]; then
    echo "Script already exists"
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

    fi
  fi

  export GITBRANCH='master'
  export IMAGE_CREATOR='Mausy5043'
  export PREIMAGE_INFO='fresh_install'
  export HW_MODEL=0
  export WIFI_REQUIRED=0
  export DISTRO_TARGET=6

  echo ""
  echo "Running script..."
  bash "${PREP_SCRIPT}"

  echo ""
  echo "Post-script actions..."
  if [ -f /tmp/dietpi.txt ]; then
    echo "Injecting custom dietpi.txt"
    cp -v /tmp/dietpi.txt /boot/
  fi
popd || exit 1
