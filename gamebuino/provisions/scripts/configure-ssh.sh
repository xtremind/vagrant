#!/bin/sh

# Set password for default "ubuntu" user
echo "ubuntu:ubuntu" | sudo chpasswd

# Copy des clefs
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh
sudo chmod 700 /home/ubuntu/.ssh/*
