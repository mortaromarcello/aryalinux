#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:light-locker:1.7.0

#REQ:lightdm
#REQ:systemd
#REQ:upower
#REQ:gnome-common

cd $SOURCE_DIR

git clone https://github.com/the-cavalry/light-locker.git
DIRECTORY=light-locker

cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "light-locker=>`date`" | sudo tee -a $INSTALLED_LIST

