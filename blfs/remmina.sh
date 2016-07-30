#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:avahi
#REQ:libssh
#REQ:libvncserver
#REQ:free-rdp
#REQ:gnome-keyring
#REQ:pulseaudio
#REQ:vte
#REQ:cmake

cd $SOURCE_DIR

git clone https://github.com/FreeRDP/Remmina.git -b next
DIRECTORY=Remmina

cd $DIRECTORY

cmake -DWITH_TELEPATHY=off -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/opt/remmina_devel/remmina -DWITH_APPINDICATOR=off -DCMAKE_PREFIX_PATH=/opt/remmina_devel/freerdp --build=build .
make &&
sudo make install
sudo ln -svf /opt/remmina_devel/remmina/bin/remmina /usr/bin/
sudo ln -svf /opt/remmina_devel/remmina/share/applications/remmina.desktop /usr/share/applications/

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "remmina=>`date`" | sudo tee -a $INSTALLED_LIST
