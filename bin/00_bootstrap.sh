#!/usr/bin/env bash

sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt -y update
sudo apt -y install build-essential
sudo apt -y install zlib1g-dev
sudo apt -y install ansible
