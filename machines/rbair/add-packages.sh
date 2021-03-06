#!/bin/bash

#echo
#echo "Installing missing default packages"
#install_package man

echo
echo "Installing additional packages..."
install_package "graphviz"

echo
echo "Installing KIMNATY package..."
su -c "git clone https://github.com/Mausy5043/kimnaty.git /home/pi/kimnaty" pi
chmod -R 0755 "/home/pi/kimnaty"
su -c "/home/pi/kimnaty/install.sh" pi
