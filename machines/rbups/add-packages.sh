#!/bin/bash

#echo
#echo "Installing missing default packages"
#install_apt_package man

echo
echo "Installing UPS monitor packages..."
apt-get -yqV install "nut"

echo
echo "Installing BUPS package..."
su -c "git clone https://github.com/Mausy5043/bups.git /home/pi/bups" pi
chmod -R 0755 "/home/pi/bups"
su -c "/home/pi/bups/bups --install" pi
