#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=1.10.0
NAME="python-modules#py2cairo"

#REQ:python2
#REQ:cairo


cd $SOURCE_DIR

URL=http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

./waf configure --prefix=/usr &&
./waf build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./waf install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
