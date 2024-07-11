#!/bin/bash

echo
echo "Installing missing default packages"

# required for HDD-support
install_apt exfat-fuse
install_apt exfat-utils
install_apt ntfs-3g
