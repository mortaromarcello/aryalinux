#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

whoami > /tmp/currentuser
sudo usermod -a -G video `cat /tmp/currentuser`

#REQ:libxml2
#REQ:util-macros
#REQ:x7proto
#REQ:libXau
#REQ:libXdmcp
#REQ:xcb-proto
#REQ:libxcb
#REQ:x7lib
#REQ:xcb-util
#REQ:xcb-util-image
#REQ:xcb-util-keysyms
#REQ:xcb-util-renderutil
#REQ:xcb-util-wm
#REQ:xcb-util-cursor
#REQ:xbitmaps
#REQ:mesa
#REQ:x7app
#REQ:xcursor-themes
#REQ:x7font
#REQ:xkeyboard-config
#REQ:xorg-server
#REQ:x7driver
#REQ:xf86-video-sis
#REQ:xf86-video-cirrus
#REQ:xf86-video-mach64
#REQ:xf86-video-mga
#REQ:xf86-video-openchrome
#REQ:xf86-video-r128
#REQ:xf86-video-savage
#REQ:xf86-video-tdfx
#REQ:xf86-video-vesa
#REQ:libva
#REQ:libva-intel-driver
#REQ:libvdpau
#REQ:libvdpau-va-gl
#REQ:twm
#REQ:xterm
#REQ:xclock
#REQ:xinit
#REQ:wayland-protocols

echo "xserver-meta=>`date`" | sudo tee -a $INSTALLED_LIST
