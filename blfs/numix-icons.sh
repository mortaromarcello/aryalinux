#!/bin/bash
set -e
set +h

#REQ:git

. /etc/alps/alps.conf

cd $SOURCE_DIR

git clone https://github.com/numixproject/numix-icon-theme.git
DIRECTORY="numix-icon-theme"
cd $DIRECTORY

sudo cp -r Numix /usr/share/icons
sudo cp -r Numix-Light /usr/share/icons

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "numix-icons=>`date`" | sudo tee -a $INSTALLED_LIST


