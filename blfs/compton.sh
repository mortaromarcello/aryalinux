#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="compton"
VERSION=SVN
DESCRIPTION="Compton is a compositor for X, and a fork of xcompmgr-dana"

#REQ:x7lib
#REQ:x7app
#REQ:x7proto
#REQ:mesa
#REQ:gtk2
#REQ:gtk3
#REQ:libconfig

cd $SOURCE_DIR
URL="https://github.com/chjj/compton/archive/master.zip"
if [ ! -z $(echo $URL | grep "/master.zip$") ] && [ ! -f $NAME-master.zip ]; then
	wget -nc $URL -O $NAME-master.zip
	TARBALL=$NAME-master.zip
elif [ ! -z $(echo $URL | grep "/master.zip$") ] && [ -f $NAME-master.zip ]; then
	echo "Tarball already downloaded. Skipping."
	TARBALL=$NAME-master.zip
else
	wget -nc $URL
	TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
fi
DIRECTORY=$(unzip -l $TARBALL | grep "/" | rev | tr -s " " | cut -d " " -f1 | rev | cut -d/ -f1 | uniq)
unzip -o $TARBALL
cd $DIRECTORY

make
sudo make MANPAGES= install
mkdir -pv ~/.config
cp -v compton.sample.conf ~/.config/compton.conf

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
