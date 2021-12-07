#!/bin/bash

# Hostname setup
sudo hostnamectl set-hostname $HOSTNAME
sudo hostname $HOSTNAME
sudo sed -i 's/127.0.1.1.*/127.0.1.1\t'"$HOSTNAME"'/g' /etc/hosts

# Install Guest Additions
cd /tmp
sudo mkdir /tmp/isomount
sudo mount -t iso9660 -o loop $HOME/VBoxGuestAdditions.iso /tmp/isomount
sudo /tmp/isomount/VBoxLinuxAdditions.run
sudo umount isomount
sudo rm -rf isomount $HOME/VBoxGuestAdditions.iso

# Disable user `ubuntu` from showing up in login screen
echo -e "[User]\nSystemAccount=true" | sudo tee /var/lib/AccountsService/users/ubuntu

# Hack to get the hosts file to update
sudo hostnamectl set-hostname $HOSTNAME
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y build-essential

sudo su qiime2 <<'EOF'
  # Remove sudo banner warning
  touch $HOME/.sudo_as_admin_successful

  # Configure gnome launcher
  dbus-launch dconf write /org/gnome/shell/favorite-apps "['org.gnome.Terminal.desktop','firefox.desktop','org.gnome.gedit.desktop','org.gnome.Nautilus.desktop']"

  # Disable `amazon` apps from showing up in the DE
  mkdir -p $HOME/.local/share/applications
  cp /usr/share/applications/ubuntu-amazon-default.desktop \
    $HOME/.local/share/applications/ubuntu-amazon-default.desktop
  echo "Hidden=true" >> $HOME/.local/share/applications/ubuntu-amazon-default.desktop
EOF
