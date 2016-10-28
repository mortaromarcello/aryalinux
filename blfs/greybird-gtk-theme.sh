#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REQ:gtk3
#REQ:ruby

cd $SOURCE_DIR

sudo gem install sass
git clone https://github.com/shimmerproject/Greybird.git
cd Greybird
./autogen.sh --prefix=/usr
sudo make install

cd $SOURCE_DIR
rm -rf Greybird

echo "greybird-gtk-theme=>`date`" | sudo tee -a $INSTALLED_LIST
