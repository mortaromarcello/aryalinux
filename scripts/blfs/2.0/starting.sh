#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus
#DEP:systemd
#DEP:xinit


cd $SOURCE_DIR






cat > ~/.xinitrc << EOF
# Begin .xinitrc

exec dbus-launch --exit-with-session startkde

# End .xinitrc
EOF


 
cd $SOURCE_DIR
 
echo "starting=>`date`" | sudo tee -a $INSTALLED_LIST