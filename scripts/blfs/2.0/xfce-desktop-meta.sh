#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxfce4util
#DEP:xfconf
#DEP:libxfce4ui
#DEP:exo
#DEP:garcon
#DEP:gtk-xfce-engine
#DEP:libwnck2
#DEP:libxfcegui4
#DEP:xfce4-panel
#DEP:xfce4-xkb-plugin
#DEP:thunar
#DEP:thunar-volman
#DEP:tumbler
#DEP:xfce4-appfinder
#DEP:xfce4-power-manager
#DEP:xfce4-settings
#DEP:xfdesktop
#DEP:xfwm4
#DEP:xfce4-session
#DEP:gnome-themes-standard
#DEP:adwaita-icon-theme
#DEP:lightdm
#DEP:lightdm-gtk-greeter
 
echo "xfce-desktop-meta=>`date`" | sudo tee -a $INSTALLED_LIST
