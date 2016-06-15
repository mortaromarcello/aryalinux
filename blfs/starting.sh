#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions


#REQ:dbus
#REQ:systemd
#REQ:xinit


cd $SOURCE_DIR

whoami > /tmp/currentuser

cat > ~/.xinitrc << EOF
# Begin .xinitrc
exec dbus-launch --exit-with-session startkde
# End .xinitrc
EOF


cd $SOURCE_DIR

echo "starting=>`date`" | sudo tee -a $INSTALLED_LIST

