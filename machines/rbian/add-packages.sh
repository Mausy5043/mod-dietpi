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

#install_apt_package libatlas-base-dev
#install_apt_package libglib2.0-dev
#install_apt_package libjpeg62
#install_apt_package libopenjp2-7
#install_apt_package libpng16-16
#install_apt_package libtiff5
#install_apt_package libxcb1
# install_apt_package nut
# install_apt_package picocom
# install_apt_package python3
# install_apt_package python3-dev
# install_apt_package python3-pip
# install_apt_package python3-scipy
# install_apt_package python3-serial
# install_apt_package sqlite3
# install_apt_package wavemon

# required for HDD-support
# install_apt_package exfat-fuse
# install_apt_package exfat-utils
# install_apt_package ntfs-3g

# required for hardware support (Bluetooth)
# install_apt_package pi-bluetooth
# install_apt_package bluetooth
# install_apt_package bluez

# sudo addgroup --gid 112 bluetooth
# sudo usermod -aG bluetooth pi
# sudo rm /etc/modprobe.d/dietpi-disable_bluetooth.conf
# sudo sed -i /^[[:blank:]]*dtoverlay=disable-bt/d /boot/config.txt


# required for hardware support (I2C & SPI)
# install_apt_package python3-rpi.gpio
# install_apt_package python3-smbus
# install_apt_package i2c-tools
# install_apt_package spi-tools

# sudo addgroup --gid 114 spi
# sudo usermod -aG spi,i2c,plugdev pi
# sudo chown root:spi /dev/spidev0.*


echo "APP WOULD BE LOADED NOW"
echo "Path: ${PATH}"
