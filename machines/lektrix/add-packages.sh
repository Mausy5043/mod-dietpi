#!/bin/bash

echo
echo "Installing additional packages..."
install_apt_package "graphviz"
install_apt_package "tmux"

echo
echo "KAMSTRUP Electricity monitor installation..."
su -c "git clone https://github.com/Mausy5043/lektrix.git /home/pi/lektrix" pi
chmod -R 0755 "/home/pi/lektrix"
# su -c "/home/pi/lektrix/lektrix --install" pi
