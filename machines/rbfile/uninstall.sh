#!/bin/bash

# stop qBitTorrent
sudo systemctl stop qbittorent.service
sleep 10

# unmount the HDD bind
if [ -d /srv/hdd ]; then
  sudo umount /mnt/dietpi_userdata
fi

# unmount USB-drive & remove mountpoint
findmnt -rno TARGET "/srv/usb" | sudo xargs -rL1 umount
sed -i '/ \/srv\/hdd /d' /etc/fstab
rmdir -v /srv/hdd
