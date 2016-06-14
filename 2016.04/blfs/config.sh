#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions


#OPT:dbus


cd $SOURCE_DIR

export KDE_PREFIX=/opt/kde


cat > ~/.xinitrc << EOF
# Begin .xinitrc
exec dbus-launch --exit-with-session startkde
# End .xinitrc
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /lib/systemd/system/kdm.service << EOF &&
[Unit]
Description=K Display Manager
After=systemd-user-sessions.service
[Service]
ExecStart=$KDE_PREFIX/bin/kdm -nodaemon
[Install]
Alias=display-manager.service
EOF
systemctl enable kdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "config=>`date`" | sudo tee -a $INSTALLED_LIST

