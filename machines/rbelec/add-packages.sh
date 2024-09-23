#!/bin/bash

echo
echo "Installing additional packages..."

# these are required for pyenv
install_apt_package build-essential
install_apt_package curl
install_apt_package gdb
install_apt_package git
install_apt_package lcov
install_apt_package libbz2-dev
install_apt_package libffi-dev
install_apt_package libgdbm-dev
install_apt_package libgdbm-compat-dev
install_apt_package liblzma-dev
# install_apt_package libncurses5-dev  # linbncursesw5-dev is considered superior
install_apt_package libncursesw5-dev
install_apt_package libreadline-dev
install_apt_package libsqlite3-dev
install_apt_package libssl-dev
install_apt_package libxml2-dev
install_apt_package libxmlsec1-dev
install_apt_package lzma
install_apt_package lzma-dev
install_apt_package pkg-config
install_apt_package tk-dev
install_apt_package uuid-dev
install_apt_package xz-utils
install_apt_package zlib1g-dev

echo
echo "KAMSTRUP Electricity monitor installation..."
su -c "git clone https://github.com/Mausy5043/lektrix.git /home/pi/lektrix" pi
chmod -R 0755 "/home/pi/lektrix"
su -c "/home/pi/lektrix/lektrix --install" pi
