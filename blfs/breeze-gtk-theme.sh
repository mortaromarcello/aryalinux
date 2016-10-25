#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:breeze-gtk-theme:SVN`date --iso-8601`

#REQ:gtk2
#REQ:gtk3
#REQ:ruby

cd $SOURCE_DIR

wget http://aryalinux.org/releases/2016.11/breeze-gtk-theme.tar.gz
sudo tar xf breeze-gtk-theme.tar.gz -C /usr/share/themes

cd $SOURCE_DIR

echo "breeze-gtk-theme=>`date`" | sudo tee -a $INSTALLED_LIST
