#!/bin/sh

# Set password for default "ubuntu" user
echo "vagrant:vagrant" | sudo chpasswd

# Copy des clefs
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh
sudo chmod 700 /home/ubuntu/.ssh/*
