#!/bin/bash

echo
echo "Installing missing default packages"

# required for HDD-support
# install_apt exfat-fuse
# install_apt exfat-utils
# install_apt ntfs-3g
install_apt smartmontools

# Mountpoint for external HDD
# /dev/sdb1        /mnt/icybox    ext4    defaults    0    2


# from raspboot

# echo
# echo "Add mountpoint for external HDD "
# sudo mkdir -p /mnt/icybox
# echo "# Mountpoint for external HDD " | sudo tee -a /etc/fstab
# echo "/dev/sdb1        /mnt/icybox    ext4    defaults    0    2" | sudo tee -a /etc/fstab
# sudo mount /mnt/icybox
# # wait for the disk to get mounted properly
# sleep 60
# sync
# sync
# echo "Add bind-mountpoints for NFS-fileserver "
# sudo mkdir -p /srv/nfs/config
# sudo mkdir -p /srv/nfs/databases
# sudo mkdir -p /srv/nfs/files
# sudo chown pi:users /srv/nfs/config
# sudo chown pi:users /srv/nfs/databases
# sudo chown pi:users /srv/nfs/files
# echo "# Exportpoints for NFS-fileserver " | sudo tee -a /etc/fstab
# echo "/mnt/icybox/config        /srv/nfs/config       none    bind    0    0" | sudo tee -a /etc/fstab
# echo "/mnt/icybox/databases     /srv/nfs/databases    none    bind    0    0" | sudo tee -a /etc/fstab
# echo "/mnt/icybox/files         /srv/nfs/files        none    bind    0    0" | sudo tee -a /etc/fstab
# sudo mount /srv/nfs/config
# sudo mount /srv/nfs/databases
# sudo mount /srv/nfs/files
echo

# NFS exports
# # /etc/exports: the access control list for filesystems which may be exported
# #		to NFS clients.  See exports(5).

# /srv/nfs/config     192.168.0.0/16(rw,subtree_check,async,insecure,no_wdelay,no_root_squash,anonuid=0,anongid=0)
# /srv/nfs/databases  192.168.0.0/16(rw,subtree_check,async,insecure,no_wdelay,no_root_squash,anonuid=0,anongid=0)
# /srv/nfs/files      192.168.0.0/16(rw,subtree_check,async,insecure,no_wdelay,no_root_squash,anonuid=0,anongid=0)
