#!/bin/bash

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

sudo tee /etc/update-motd.d/00-header > /dev/null << EOL
#!/bin/sh

[ -r /etc/lsb-release ] && . /etc/lsb-release
if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
    DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi
printf "Welcome to QIIME 2 Core ${QIIME2_RELEASE}!\n\n"
EOL

sudo tee /etc/update-motd.d/10-help-text > /dev/null << EOL
#!/bin/sh

printf "  * Documentation: https://docs.qiime2.org/\n"
printf "  * Support: https://forum.qiime2.org/\n"
EOL

sudo rm /etc/update-motd.d/51-cloudguest
