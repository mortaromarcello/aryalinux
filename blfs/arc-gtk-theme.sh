#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

git clone https://github.com/horst3180/arc-theme --depth 1 && cd arc-theme
./autogen.sh --prefix=/usr
sudo make install

cd $SOURCE_DIR
rm -rf arc-theme

git clone https://github.com/horst3180/arc-firefox-theme && cd arc-firefox-theme
./autogen.sh --prefix=/usr
sudo make install

cd $SOURCE_DIR
rm -rf arc-firefox-theme

echo "arc-gtk-theme=>`date`" | sudo tee -a $INSTALLED_LIST
