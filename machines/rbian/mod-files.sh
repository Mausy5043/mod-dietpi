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
# su -c "PATH=/home/${USER}/.pyenv/bin:$PATH eval $(/home/${USER}/.pyenv/bin/pyenv init -)" "${USER}"
# su -c "PATH=/home/${USER}/.pyenv/bin:$PATH; eval \"\$(pyenv init -)\"" "${USER}"
su - "${USER}" -c <<EOF
PATH=/home/${USER}/.pyenv/bin:\$PATH
eval "\$(/home/${USER}/.pyenv/bin/pyenv init -)"
EOF

#su -c "PATH=/home/${USER}/.pyenv/bin:$PATH /home/${USER}/.pyenv/bin/pyenv install  3.12" "${USER}"
su - "${USER}" -c <<EOF
PATH=/home/${USER}/.pyenv/bin:\$PATH
eval "\$(/home/${USER}/.pyenv/bin/pyenv install 3.12)"
EOF

#su -c "PATH=/home${USER}/.pyenv/bin:$PATH /home/${USER}/.pyenv/bin/pyenv global   3.12" "${USER}"
su - "${USER}" -c <<EOF
PATH=/home/${USER}/.pyenv/bin:\$PATH
eval "\$(/home/${USER}/.pyenv/bin/pyenv global 3.12)"
EOF
