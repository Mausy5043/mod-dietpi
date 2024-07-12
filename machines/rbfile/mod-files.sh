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
