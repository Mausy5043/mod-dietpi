#!/bin/bash

echo
echo "Installing additional packages..."
install_package graphviz

echo
echo "KAMSTRUP Electricity monitor installation..."
su -c "git clone -b zappi https://gitlab.com/mausy5043-diagnostics/kamstrupd.git /home/pi/kamstrupd" pi
chmod -R 0755 "/home/pi/kamstrupd"
su -c "/home/pi/kamstrupd/install.sh" pi
