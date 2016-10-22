#!/bin/bash
set -e
set +h

#REQ:git
#REQ:numix-icons

. /etc/alps/alps.conf

cd $SOURCE_DIR

git clone https://github.com/numixproject/numix-icon-theme-circle.git
DIRECTORY="numix-icon-theme-circle"
cd $DIRECTORY

sudo cp -r Numix-Circle /usr/share/icons
sudo cp -r Numix-Circle-Light /usr/share/icons

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "numix-icons-circle=>`date`" | sudo tee -a $INSTALLED_LIST


