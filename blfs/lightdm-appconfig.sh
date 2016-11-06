#!/bin/bash

set -e
set +h

function postinstall()
{

getent group lightdm > /dev/null || groupadd -g 63 lightdm
getent passwd lightdm > /dev/null || useradd -c "Light Display Manager" -u 63 -g lightdm -d /var/lib/lightdm -s /sbin/nologin lightdm

chown -R lightdm:lightdm /var/lib/lightdm /var/log/lightdm

chmod 700 /usr/share/polkit-1/rules.d
chmod 600 /usr/share/polkit-1/rules.d/*
chown -R polkitd:polkitd /usr/share/polkit-1/rules.d

systemctl enable lightdm

}

function preinstall()
{
echo "#"
}

$1
