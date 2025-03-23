#!/bin/bash

echo ""
echo -n "Modify /boot/config.txt "
{
  echo ""
  echo "#>>> Added by Automation_Custom_Script.sh"
  echo "dtparam=pwr_led_trigger=heartbeat"
  echo "dtparam=act_led_trigger=heartbeat"
  echo "#<<< Added by Automation_Custom_Script.sh"
  echo ""
}>> /boot/config.txt

echo -n "Change LED control after boot"
echo "@reboot           root    echo cpu >  /sys/class/leds/led0/trigger" | sudo tee /etc/cron.d/99leds
echo "@reboot           root    echo mmc1 > /sys/class/leds/led1/trigger" | sudo tee -a /etc/cron.d/99leds

echo ""
echo "Installing pyenv for user ${USER} ..."
su -c "curl https://pyenv.run | bash" "${USER}"
su -c "echo \$PATH" "${USER}"
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv init -)\"" "${USER}"
date  +"%Y.%m.%d %H:%M:%S"

echo "Creating Python 3.13..."
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv install 3.13)\"" "${USER}"
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv global 3.13)\"" "${USER}"
# echo "Creating Python 3.14..."
# su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv install 3.14)\"" "${USER}"
echo ""
date  +"%Y.%m.%d %H:%M:%S"

echo "Installing KIMNATY package..."
su -c ". /home/pi/.paths; /home/${USER}/kimnaty/kimnaty --install" -l "${USER}"
echo ""
date  +"%Y.%m.%d %H:%M:%S"

echo "Installing LEKTRIX package..."
su -c ". /home/pi/.paths; /home/${USER}/lektrix/lektrix --install" -l "${USER}"
echo""
date  +"%Y.%m.%d %H:%M:%S"

echo "Installing WIZWTR package..."
su -c ". /home/pi/.paths; /home/${USER}/wizwtr/wizwtr --install" -l "${USER}"
echo""
date  +"%Y.%m.%d %H:%M:%S"
