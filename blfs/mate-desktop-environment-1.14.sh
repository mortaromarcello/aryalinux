#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gobject-introspection
#REQ:desktop-file-utils
#REQ:shared-mime-info
#REQ:libxml2
#REQ:libxslt
#REQ:glib2
#REQ:libidl
#REQ:dbus
#REQ:dbus-glib
#REQ:polkit
#REQ:popt
#REQ:libgcrypt
#REQ:gtk2
#REQ:libcanberra
#REQ:libart
#REQ:libglade
#REQ:libtasn1
#REQ:libxklavier
#REQ:libsoup
#REQ:icon-naming-utils
#REQ:libunique
#REQ:libwnck
#REQ:librsvg
#REQ:upower
#REQ:intltool
#REQ:libtasn1
#REQ:libtool
#REQ:xmlto
#REQ:gtk-doc
#REQ:rarian
#REQ:dconf
#REQ:libsecret
#REQ:gnome-keyring
#REQ:libnotify
#REQ:libwnck2
#REQ:zenity
#REQ:yelp
#REQ:xdg-utils
#REQ:xdg-user-dirs
#REQ:libgtop

#REQ:mate-common-1.14
#REQ:mate-desktop-1.14
#REQ:libmatekbd-1.14
#REQ:libmatewnck
#REQ:libmateweather-1.14
#REQ:mate-icon-theme-1.14
#REQ:caja-1.14
#REQ:marco-1.14
#REQ:mate-settings-daemon-1.14
#REQ:mate-session-manager-1.14
#REQ:mate-menus-1.14
#REQ:mate-panel-1.14
#REQ:mate-control-center-1.14
#REQ:lightdm
#REQ:lightdm-gtk-greeter
#REQ:plymouth
#REQ:mate-screensaver-1.14

#REQ:mate-terminal-1.14
#REQ:caja-1.14
#REQ:caja-extensions-1.14
#REQ:caja-dropbox-1.14
#REQ:pluma-1.14
#REQ:galculator
#REQ:gpicview
#REQ:engrampa-1.14
#REQ:mate-utils-1.14
#REQ:murrine-gtk-engine
#REQ:mate-themes-gtk3
#REQ:gnome-themes-standard
#REQ:adwaita-icon-theme
#REQ:mate-system-monitor-1.14
#REQ:mate-power-manager-1.14
#REQ:marco-1.14
#REQ:python-modules#pygobject2
#REQ:mozo-1.14
#REQ:mate-backgrounds-1.14
#REQ:mate-media-1.14

#REQ:wireless_tools
#REQ:wpa_supplicant
#REQ:networkmanager
#REQ:network-manager-applet
#REQ:net-tools
#REQ:ModemManager
#REQ:usb_modeswitch

echo "mate-desktop-environment-1.14=>`date`" | sudo tee -a $INSTALLED_LIST
