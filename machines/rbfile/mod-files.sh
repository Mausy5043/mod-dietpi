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

echo ""
echo "Installing pyenv for user..."
su -c "curl https://pyenv.run | bash" "${USER}"
echo "Creating Python 3.12..."
su -c "echo \$PATH" "${USER}"
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv init -)\"" "${USER}"
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv install 3.12)\"" "${USER}"
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv global 3.12)\"" "${USER}"

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
      echo "UUID=${HDD_ID}  ${HDD_DIR}                   ext4  defaults  0  2"
      echo "/srv/hdd/files                             /mnt/dietpi_userdata       none  bind      0  0"
      echo "/srv/hdd/_config/qbittorrent/_config       /home/qbittorrent/.config  none  bind      0  0"
      echo "/srv/hdd/_config/qbittorrent/_local        /home/qbittorrent/.local   none  bind      0  0"
    } >> /etc/fstab

    echo "Mounting HDD-drive..."
    mount "${HDD_DIR}"
    # wait for the disk to get mounted properly
    sleep 60
  fi

# old NFS exports
# /srv/nfs/config     192.168.0.0/16(rw,subtree_check,async,insecure,no_wdelay,no_root_squash,anonuid=0,anongid=0)
# /srv/nfs/databases  192.168.0.0/16(rw,subtree_check,async,insecure,no_wdelay,no_root_squash,anonuid=0,anongid=0)
# /srv/nfs/files      192.168.0.0/16(rw,subtree_check,async,insecure,no_wdelay,no_root_squash,anonuid=0,anongid=0)
