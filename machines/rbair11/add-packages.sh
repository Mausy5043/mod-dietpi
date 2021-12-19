#!/bin/bash

echo "Installing WIFI support..."
install_package "wavemon"
install_package "usbutils"

echo "Installing Bluetooth support..."
install_package "pi-bluetooth"

echo
echo "Installing additional packages..."
install_package "graphviz"
