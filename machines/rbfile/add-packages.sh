#!/bin/bash

echo
echo "Installing missing default packages"
install_apt_package man
install_apt_package "graphviz"
install_apt_package "tmux"

# required for HDD-support
install_apt exfat-fuse
install_apt exfat-utils
install_apt ntfs-3g