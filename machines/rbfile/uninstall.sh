#!/bin/bash

sudo systemctl stop qbittorent.service
echo "qBitTorrent stopped"
sudo systemctl stop smbd.service
echo "Samba stopped"
sudo systemctl stop nfs-kernel-server.service
echo "NFS stopped"
sleep 10


# unmount the HDD binds
echo "unmounting /home/qbittorrent/.config"
  sudo umount /home/qbittorrent/.config
echo "unmounting /home/qbittorrent/.local"
  sudo umount /home/qbittorrent/.local
sed -i '/qbittorrent/d' /etc/fstab
if [ -d /srv/hdd ]; then
  echo "unmounting /mnt/dietpi_userdata"
  sudo umount /mnt/dietpi_userdata
  sed -i '/ \/mnt\/dietpi_userdata /d' /etc/fstab
fi

# unmount USB-drive & remove mountpoint
echo "unmounting HDD"
findmnt -rno TARGET "/srv/hdd" | sudo xargs -rL1 umount
sed -i '/ \/srv\/hdd /d' /etc/fstab
#rmdir -v /srv/hdd
