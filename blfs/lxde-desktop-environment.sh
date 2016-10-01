#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:lxmenu-data
#REQ:libfm-extra
#REQ:menu-cache
#REQ:libfm
#REQ:pcmanfm
#REQ:lxpanel
#REQ:lxappearance
#REQ:lxsession
#REQ:lxde-common
#REQ:gpicview
#REQ:lxappearance-obconf
#REQ:lxinput
#REQ:lxrandr
#REQ:lxtask
#REQ:lxterminal

echo "gnome-desktop-environment=>`date`" | sudo tee -a $INSTALLED_LIST
