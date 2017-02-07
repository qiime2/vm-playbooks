#!/usr/bin/env bash

sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt -y update
sudo apt -y install ansible
