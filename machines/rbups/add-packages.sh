#!/bin/bash

#echo
#echo "Installing missing default packages"
#install_package man

echo
echo "Installing UPS monitor packages..."
install_package nut
install_package graphviz

echo
echo "Installing UPSDIAGD package..."
su -c "git clone https://github.com/Mausy5043/upsdiagd.git /home/pi/upsdiagd" pi
chmod -R 0755 "/home/pi/upsdiagd"
su -c '/home/pi/upsdiagd/install.sh' pi
