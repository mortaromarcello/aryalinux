#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 64 sddm &&
useradd  -c "SDDM Daemon" \
         -d /var/lib/sddm \
         -u 64 -g sddm    \
         -s /bin/false sddm

}

function postinstall()
{

. /sources/build-properties
echo "setxkbmap $KEYBOARD" >> /usr/share/sddm/scripts/Xsetup
echo "source /etc/profile.d/dircolors.sh" >> /etc/bashrc

}




$1
