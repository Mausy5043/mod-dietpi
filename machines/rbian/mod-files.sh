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
echo "Installing pyenv for user ${USER}"
su -c "curl https://pyenv.run | bash" "${USER}"
echo "Creating Python 3.12..."
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv init -)\"" "${USER}"
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv install 3.12)\"" "${USER}"
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv global 3.12)\"" "${USER}"
echo "Creating Python 3.12..."
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv install 3.13)\"" "${USER}"
echo "Creating Python 3.12..."
su -c "export \"PATH=/home/${USER}/.pyenv/bin:\$PATH\"; eval \"\$(/home/${USER}/.pyenv/bin/pyenv install 3.14)\"" "${USER}"

echo "I am $(whoami)"
echo
echo "PYENV ACTIVE HERE"
su -c "echo \"$(whoami) PATH=$PATH\"" -l "${USER}"

# execute .paths to create ~/.pyenvpaths
su -c '. /home/pi/.paths; echo $PATH' -l "${USER}"
# record the result in the log
su -c "ls -al" -l "${USER}"
echo
su -c "echo '$(whoami) PATH=$PATH'" -l "${USER}"
echo
cat "/home/${USER}/.pyenvpaths"
echo
echo "INSTALL APP(s) HERE"
su -c '. /home/pi/.paths; python -V' -l "${USER}"
echo
