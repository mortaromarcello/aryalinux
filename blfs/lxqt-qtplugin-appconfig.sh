#!/bin/bash
set -e
set +h

function postinstall()
{

cat >> /etc/profile.d/lxqt.sh << "EOF"
# Begin lxqt-qtplugin configuration
export QT_QPA_PLATFORMTHEME=lxqt
# End lxqt-qtplugin configuration
EOF

}


preinstall()
{
echo "#"
}


$1
