#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > ~/.xinitrc << EOF
# Begin .xinitrc

exec dbus-launch --exit-with-session startkde

# End .xinitrc
EOF

cat > 1434987998799.sh << "ENDOFFILE"
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
ENDOFFILE
chmod a+x 1434987998799.sh
sudo ./1434987998799.sh
sudo rm -rf 1434987998799.sh


 
cd $SOURCE_DIR
 
echo "config=>`date`" | sudo tee -a $INSTALLED_LIST