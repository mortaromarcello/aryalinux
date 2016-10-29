#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
