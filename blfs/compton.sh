#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REQ:gtk3
#REQ:libconfig

cd $SOURCE_DIR

git clone https://github.com/chjj/compton.git
make
sudo make MANPAGES= install

cd $SOURCE_DIR
rm -rf compton

echo "compton=>`date`" | sudo tee -a $INSTALLED_LIST
