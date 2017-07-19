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

# Install nodejs
curl -sL https://deb.nodesource.com/setup_7.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
rm nodesource_setup.sh
# Hack to get the hosts file to update
sudo hostnamectl set-hostname $HOSTNAME
sudo apt-get install -y nodejs build-essential

# Install q2studio
cd /opt/
sudo wget -O "q2studio-${QIIME2_RELEASE}.0.zip" "https://codeload.github.com/qiime2/q2studio/zip/${QIIME2_RELEASE}.0"
sudo unzip q2studio-${QIIME2_RELEASE}.0.zip
sudo rm q2studio-${QIIME2_RELEASE}.0.zip
cd q2studio-${QIIME2_RELEASE}.0
sudo npm install
sudo npm run build
sudo su qiime2 -s /bin/bash -c "cd /opt/q2studio-${QIIME2_RELEASE}.0/;/home/qiime2/miniconda/envs/qiime2-${QIIME2_RELEASE}/bin/pip install ."
sudo wget -O /usr/share/icons/hicolor/q2studio.png https://raw.githubusercontent.com/qiime2/logos/master/raster/white/qiime2-square-100.png

sudo cat <<EOF > /tmp/q2studio.desktop
[Desktop Entry]
Version=1.0
Exec=bash -c "/usr/bin/env PATH=/home/qiime2/miniconda/envs/qiime2-${QIIME2_RELEASE}/bin:$(echo '$PATH') npm start --prefix /opt/q2studio-${QIIME2_RELEASE}.0"
Name=q2studio
Icon=/usr/share/icons/hicolor/q2studio.png
GenericName=q2studio
Comment=QIIME 2 Studio
Encoding=UTF-8
Terminal=false
Type=Application
Categories=Application;
EOF

sudo mv /tmp/q2studio.desktop /usr/share/applications/q2studio.desktop

# Install leafpad and make default GUI text editor
sudo apt-get install leafpad -q -y
sudo sed -i 's/text\/plain=gedit.desktop/text\/plain=leafpad.desktop/g' /usr/share/applications/defaults.list

sudo su qiime2 <<'EOF'
  # Remove sudo banner warning
  touch $HOME/.sudo_as_admin_successful

  # Configure unity launcher
  dbus-launch gsettings set com.canonical.Unity.Launcher favorites \
    "['application://gnome-terminal.desktop','application://q2studio.desktop','application://firefox.desktop','application://leafpad.desktop','application://org.gnome.Nautilus.desktop','unity://running-apps','unity://expo-icon','unity://devices']"

  # Disable `amazon` apps from showing up in unity
  mkdir -p $HOME/.local/share/applications
  cp /usr/share/applications/ubuntu-amazon-default.desktop \
    $HOME/.local/share/applications/ubuntu-amazon-default.desktop
  echo "Hidden=true" >> $HOME/.local/share/applications/ubuntu-amazon-default.desktop
EOF
