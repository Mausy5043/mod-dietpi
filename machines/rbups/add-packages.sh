#!/bin/bash

echo "Installing missing default packages"
install_package man

echo "Installing UPS monitor packages..."
install_package nut
install_package graphviz

echo "Installing UPSDIAGD package..."
su -c "git clone https://gitlab.com/mausy5043-diagnostics/upsdiagd.git /home/pi/upsdiagd" pi
chmod -R 0755 "/home/pi/upsdiagd"
su -c '/home/pi/upsdiagd/install.sh' pi
