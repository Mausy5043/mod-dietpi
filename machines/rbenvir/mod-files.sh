#!/bin/bash

echo ""
echo -n "Modify /boot/config.txt "
{
  echo ""
  echo "#>>> Added by Automation_Custom_Script.sh"
  # echo "dtoverlay=lirc-rpi,gpio_in_pin=17,gpio_out_pin=22"
  echo "dtparam=pwr_led_trigger=heartbeat"
  echo "dtparam=act_led_trigger=heartbeat"
  echo "#<<< Added by Automation_Custom_Script.sh"
  echo ""
}>> /boot/config.txt

#sudo systemctl enable systemd-journal-upload.service
#sudo systemctl start systemd-journal-upload.service

echo -n "Change LED control after boot"
echo "@reboot           root    echo cpu >  /sys/class/leds/led0/trigger" | sudo tee -a /etc/cron.d/99leds
echo "@reboot           root    echo mmc1 > /sys/class/leds/led1/trigger" | sudo tee -a /etc/cron.d/99leds
