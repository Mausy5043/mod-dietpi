#!/bin/bash

echo ""
echo -n "Modify /boot/config.txt "
{
  echo ""
  echo "#>>> Added by Automation_Custom_Script.sh"
  echo "dtoverlay=lirc-rpi,gpio_in_pin=17,gpio_out_pin=22"
  echo "dtparam=pwr_led_trigger=heartbeat"
  echo "dtparam=act_led_trigger=heartbeat"
  echo "#<<< Added by Automation_Custom_Script.sh"
  echo ""
}>> /boot/config.txt

# Bluetooth enable
# sed -i 's/dtoverlay=disable-bt/\#dtoverlay=disable-bt/g' /boot/config.txt
# I2C enable
sed -i 's/\#dtparam=i2c_arm=o.*$/dtparam=i2c_arm=on/g' /boot/config.txt
sed -i 's/\#dtparam=i2c_arm_baud.*$/dtparam=i2c_arm_baudrate=10000/g' /boot/config.txt
# SPI enable
sed -i 's/\#dtparam=spi=o.*$/dtparam=spi=on/g' /boot/config.txt

echo "[OK]"

echo -n "Change LED control after boot"
echo "@reboot           root    echo cpu >  /sys/class/leds/led0/trigger" | sudo tee /etc/cron.d/99leds
echo "@reboot           root    echo mmc1 > /sys/class/leds/led1/trigger" | sudo tee -a /etc/cron.d/99leds
#
## switch off annoying eth0
echo "@reboot           root    sleep 120; systemctl stop ifup@eth0.service" | sudo tee /etc/cron.d/98no-eth0
#
#echo "[OK]"

#sudo systemctl enable systemd-journal-upload.service
#sudo systemctl start systemd-journal-upload.service
