#!/bin/bash

# NOTE: We don't set up the hostname on AWS, because dynamic hostnames are
# a thing on AWS that we don't want to mess with:
# https://stackoverflow.com/a/12900022/313548
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

sudo tee /etc/update-motd.d/00-header <<EOF
#!/bin/sh

[ -r /etc/lsb-release ] && . /etc/lsb-release
if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
    DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi
printf "Welcome to QIIME 2 Core ${QIIME2_RELEASE}!\n\n"
EOF

sudo tee /etc/update-motd.d/10-help-text <<EOF
#!/bin/sh

printf "  * Documentation: https://docs.qiime2.org/\n"
printf "  * Support: https://forum.qiime2.org/\n"
EOF

sudo rm /etc/update-motd.d/51-cloudguest
