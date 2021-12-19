#!/bin/bash

echo "Modifying installation..."
echo ""
echo -n "Modify /boot/config.txt "
{
  echo ""
  echo "###### Added by Automation_Custom_Script.sh"
  echo "dtoverlay=lirc-rpi,gpio_in_pin=17,gpio_out_pin=22"
  echo "dtparam=pwr_led_trigger=heartbeat"
  echo "dtparam=act_led_trigger=heartbeat"
  echo "###### Added by Automation_Custom_Script.sh"
}>> /boot/config.txt

# Bluetooth enable
sed -i 's/dtoverlay=disable-bt/\#dtoverlay=disable-bt/g' /boot/config.txt


echo -n "Change LED control after boot"
echo "@reboot           root    echo cpu >  /sys/class/leds/led0/trigger" | tee -a /etc/cron.d/99leds
echo "@reboot           root    echo mmc1 > /sys/class/leds/led1/trigger" | tee -a /etc/cron.d/99leds

# switch off annoying eth0
# echo "@reboot           root    sleep 120; systemctl stop ifup@eth0.service" | tee -a /etc/cron.d/98no-eth0

echo "Installing AIRCON package..."
su -c "git clone https://gitlab.com/mausy5043-raspberrypi-io/aircon.git /home/pi/aircon" pi
pushd "/home/pi/aircon" || exit 1
  su -c "./install.sh" pi
  su -c "./update.sh" pi
popd || exit 1
