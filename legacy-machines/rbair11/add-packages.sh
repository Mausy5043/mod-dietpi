#!/bin/bash

#echo
#echo "Installing missing default packages"
#install_apt_package man

echo "Installing WIFI support..."
install_apt_package "wavemon"
# install_apt_package "usbutils"

# echo "Installing Bluetooth support..."
# install_apt_package "pi-bluetooth"

echo
echo "Installing additional packages..."
install_apt_package "graphviz"

#su -c "python3 -m pip install adafruit-circuitpython-bmp280" pi
#su -c "python3 -m pip install adafruit-circuitpython-ccs811" pi
#su -c "python3 -m pip install adafruit-circuitpython-sht31d" pi
#su -c "python3 -m pip install luma.oled" pi

echo
echo "Installing AIRCON package..."
su -c "git clone https://gitlab.com/mausy5043-raspberrypi-io/aircon.git /home/pi/aircon" pi
chmod -R 0755 "/home/pi/aircon"
su -c "/home/pi/aircon/install.sh" pi
