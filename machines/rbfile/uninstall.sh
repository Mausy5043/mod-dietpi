#!/bin/bash

# stop qBitTorrent
sudo systemctl stop qbittorent.service
sleep 10

# unmount the HDD bind
if [ -d /srv/hdd ]; then
  echo "unmounting /mnt/dietpi_userdata"
  sudo umount /mnt/dietpi_userdata
  sed -i '/ \/mnt\/dietpi_userdata /d' /etc/fstab
fi

# unmount USB-drive & remove mountpoint
echo "unmounting HDD"
findmnt -rno TARGET "/srv/hdd" | sudo xargs -rL1 umount
sed -i '/ \/srv\/hdd /d' /etc/fstab
rmdir -v /srv/hdd
