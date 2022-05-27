#!/bin/sh
set -ex

# https://askubuntu.com/questions/1067929/on-18-04-package-virtualbox-guest-utils-does-not-exist
sudo apt-add-repository multiverse
sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y enlightenment
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

#autologin 
sudo test -f /etc/gdm3/custom.conf && sudo cp /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak && sudo rm -f /etc/gdm3/custom.conf
sudo cp /vagrant/provisions/files/desktop/custom.conf /etc/gdm3/custom.conf
#auto desktop
sudo test -f /var/lib/AccountsService/users/ubuntu.conf && sudo cp /var/lib/AccountsService/users/ubuntu.conf /var/lib/AccountsService/users/ubuntu.bak && sudo rm -f /var/lib/AccountsService/users/ubuntu.conf
sudo cp /vagrant/provisions/files/desktop/ubuntu.conf /var/lib/AccountsService/users/ubuntu
sudo sed -i 's/XSession\=.*/XSession\=enlightenment/g' /var/lib/AccountsService/users/ubuntu


# Use French keyboard layout
L='fr' && sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard
sudo sed --in-place s/us/fr/g /etc/default/keyboard

# Default appearance

