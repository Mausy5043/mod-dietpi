#!/bin/bash

echo ""
echo "Modify /boot/config.txt "
{
  echo ""
  echo "#>>> Added by Automation_Custom_Script.sh"
  # echo "dtoverlay=lirc-rpi,gpio_in_pin=17,gpio_out_pin=22"
  echo "dtparam=pwr_led_trigger=heartbeat"
  echo "dtparam=act_led_trigger=heartbeat"
  echo "#<<< Added by Automation_Custom_Script.sh"
  echo ""
}>> /boot/config.txt

echo "Change LED control after boot"
{
  echo "@reboot           root    echo cpu >  /sys/class/leds/led0/trigger"
  echo "@reboot           root    echo mmc1 > /sys/class/leds/led1/trigger"
}>> /etc/cron.d/99leds

# UUID=a09a9aa2-9d56-46ed-9d0d-48ea742e4473 /srv/usb ext4 noatime,lazytime,rw,noauto,x-systemd.automount
# UUID=3729940f-c896-49f2-b71f-33f64ae89e46 /srv/hdd ext4 noatime,lazytime,rw,noauto,x-systemd.automount

  # is external HDD attached?
  HDD_ID="$(lsblk -o NAME,UUID |grep $(lsblk -o NAME,MODEL |grep WDC |awk '{print $1}') |awk  'NF>1 {print $2}')"
  HDD_DEV="$(lsblk -pro NAME,UUID |grep ${HDD_ID} |awk '{print $1}')"
  if [ -e "${HDD_DEV}" ]; then
    echo "Detected HDD-drive..."
    HDD_DIR="/srv/hdd"
    if [ ! -d "${HDD_DIR}" ]; then
      # DietPi will have detected it too. Remove the entry in /etc/fstab
      sed -i "/${HDD_ID}/d" /etc/fstab
      #sed -i '/ \/srv\/hdd /d' /etc/fstab
      claim_path "${HDD_DIR}"
    else
      echo "Mountpoint for HDD already exists."
    fi

    echo "Adding HDD-drive to /etc/fstab..."
    {
      echo "UUID=${HDD_ID}        ${HDD_DIR}        ext4        defaults        0    2"
      echo "/srv/hdd/files        /mnt/dietpi_userdata        none        bind        0    0"
    } >> /etc/fstab

    echo "Mounting HDD-drive..."
    mount "${HDD_DIR}"
    # wait for the disk to get mounted properly
    sleep 60
  fi



# from raspboot

# echo
# echo "Add mountpoint for external HDD "
# sudo mkdir -p /mnt/icybox
# echo "# Mountpoint for external HDD " | sudo tee -a /etc/fstab
# echo "/dev/sdb1        /mnt/icybox    ext4    defaults    0    2" | sudo tee -a /etc/fstab
# sudo mount /mnt/icybox
# sync
# sync
# sudo mkdir -p /srv/nfs/config
# sudo mkdir -p /srv/nfs/databases
# sudo mkdir -p /srv/nfs/files
# sudo chown pi:users /srv/nfs/config
# sudo chown pi:users /srv/nfs/databases
# sudo chown pi:users /srv/nfs/files
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
