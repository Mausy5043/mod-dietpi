#!/bin/bash

echo
echo "Installing additional packages..."
install_apt_package build-essential
install_apt_package graphviz
install_apt_package "tmux"
#install_apt_package libatlas-base-dev
#install_apt_package libglib2.0-dev
#install_apt_package libjpeg62
#install_apt_package libopenjp2-7
#install_apt_package libpng16-16
#install_apt_package libtiff5
#install_apt_package libxcb1
install_apt_package man
# install_apt_package nut
install_apt_package picocom
install_apt_package python3
install_apt_package python3-dev
install_apt_package python3-pip
install_apt_package python3-scipy
install_apt_package python3-serial
install_apt_package sqlite3
install_apt_package wavemon

# required for HDD-support
install_apt exfat-fuse
install_apt exfat-utils
install_apt ntfs-3g

# required for hardware support (Bluetooth)
install_apt_package pi-bluetooth
install_apt_package bluetooth
install_apt_package bluez

sudo addgroup --gid 112 bluetooth
sudo usermod -aG bluetooth pi
sudo rm /etc/modprobe.d/dietpi-disable_bluetooth.conf
sudo sed -i /^[[:blank:]]*dtoverlay=disable-bt/d /boot/config.txt


# required for hardware support (I2C & SPI)
install_apt_package python3-rpi.gpio
install_apt_package python3-smbus
install_apt_package i2c-tools
install_apt_package spi-tools

sudo addgroup --gid 114 spi
sudo usermod -aG spi,i2c,plugdev pi
sudo chown root:spi /dev/spidev0.*
