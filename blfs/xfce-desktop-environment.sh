#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="xfce-desktop-environment"
DESCRIPTION="A popular lightweight gtk based desktop environment"
VERSION=4.12

#REQ:gobject-introspection
#REQ:desktop-file-utils
#REQ:shared-mime-info

#REQ:libxfce4util
#REQ:xfconf
#REQ:libxfce4ui
#REQ:exo
#REQ:garcon
#REQ:gtk-xfce-engine
#REQ:libwnck2
#REQ:xfce4-panel
#REQ:xfce4-xkb-plugin
#REQ:thunar
#REQ:thunar-volman
#REQ:tumbler
#REQ:xfce4-appfinder
#REQ:xfce4-power-manager
#REQ:xfce4-settings
#REQ:xfdesktop
#REQ:xfwm4
#REQ:xfce4-session
#REQ:mousepad
#REQ:vte2
#REQ:xfce4-terminal
#REQ:xfburn
#REQ:ristretto
#REQ:xfce4-notifyd
#REQ:pnmixer
#REQ:xfce4-whiskermenu-plugin
#REQ:xfce4-screenshooter
#REQ:p7zip-full
#REQ:xarchiver
#REQ:imagemagick
#REQ:thunar-plugins
#REQ:xdg-utils
#REQ:xdg-user-dirs
#REQ:galculator
#REQ:epdfview

#REQ:gcr
#REQ:gvfs
#REQ:polkit-gnome

#REQ:plymouth
#REQ:lightdm
#REQ:lightdm-gtk-greeter

#REQ:murrine-gtk-engine
#REQ:adwaita-icon-theme

#REQ:wireless_tools
#REQ:wpa_supplicant
#REQ:networkmanager
#REQ:ModemManager
#REQ:network-manager-applet
#REQ:net-tools
#REQ:usb_modeswitch
#REQ:compton

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
