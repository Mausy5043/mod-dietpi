#!/bin/bash

echo
echo "Installing additional packages..."
install_package build-essential
install_package graphviz
install_package lftp
install_package libatlas-base-dev
install_package libglib2.0-dev
install_package libjpeg62
install_package libopenjp2-7
install_package libpng16-16
install_package libtiff5
install_package libxcb1
install_package man
# install_package nut
install_package picocom
install_package python3
install_package python3-dev
install_package python3-pip
install_package python3-scipy
install_package python3-serial
install_package sqlite3
install_package wavemon


# required for hardware support (Bluetooth)
install_package pi-bluetooth
install_package bluetooth
install_package bluez

sudo addgroup --gid 112 bluetooth
sudo usermod -aG bluetooth pi
sudo rm /etc/modprobe.d/dietpi-disable_bluetooth.conf
sudo sed -i /^[[:blank:]]*dtoverlay=disable-bt/d /boot/config.txt


# required for hardware support (I2C & SPI)
install_package python3-rpi.gpio
install_package python3-smbus
install_package i2c-tools
install_package spi-tools

sudo addgroup --gid 114 spi
sudo usermod -aG spi,i2c,plugdev pi
sudo chown root:spi /dev/spidev0.*
