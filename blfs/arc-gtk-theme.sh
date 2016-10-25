#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:arc-gtk-theme:SVN`date --iso-8601`

#REQ:gtk2
#REQ:gtk3
#REQ:git

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
