#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep sddm /etc/group &> /dev/null; then

groupadd -g 64 sddm &&
useradd  -c "SDDM Daemon" \
         -d /var/lib/sddm \
         -u 64 -g sddm    \
         -s /bin/false sddm
fi

. /sources/build-properties
echo "setxkbmap $KEYBOARD" >> /usr/share/sddm/scripts/Xsetup
echo "source /etc/profile.d/dircolors.sh" >> /etc/bashrc

}


function preinstall()
{
echo "#"
}

$1
