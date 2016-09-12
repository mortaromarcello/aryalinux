#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr
sudo make install

cd $SOURCE_DIR
rm -rf vertex-theme

echo "arc-gtk-theme=>`date`" | sudo tee -a $INSTALLED_LIST
