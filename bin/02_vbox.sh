#!/bin/bash

# Install Guest Additions
cd /tmp
sudo mkdir /tmp/isomount
sudo mount -t iso9660 -o loop $HOME/VBoxGuestAdditions.iso /tmp/isomount
sudo /tmp/isomount/VBoxLinuxAdditions.run
sudo umount isomount
sudo rm -rf isomount $HOME/VBoxGuestAdditions.iso

# Disable user `ubuntu` from showing up in login screen
echo -e "[User]\nSystemAccount=true" | sudo tee /var/lib/AccountsService/users/ubuntu

# Install leafpad and make default GUI text editor
sudo apt-get install leafpad -q -y
sudo sed -i 's/text\/plain=gedit.desktop/text\/plain=leafpad.desktop/g' /usr/share/applications/defaults.list

sudo su qiime2 <<'EOF'
  # Remove sudo banner warning
  touch $HOME/.sudo_as_admin_successful

  # Configure unity launcher
  dbus-launch gsettings set com.canonical.Unity.Launcher favorites \
    "['application://gnome-terminal.desktop','application://firefox.desktop','application://leafpad.desktop','application://org.gnome.Nautilus.desktop','unity://running-apps','unity://expo-icon','unity://devices']"

  # Disable `amazon` apps from showing up in unity
  mkdir -p $HOME/.local/share/applications
  cp /usr/share/applications/ubuntu-amazon-default.desktop \
    $HOME/.local/share/applications/ubuntu-amazon-default.desktop
  echo "Hidden=true" >> $HOME/.local/share/applications/ubuntu-amazon-default.desktop
EOF
