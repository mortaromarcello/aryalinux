#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak JS is Mozilla's JavaScript enginebr3ak written in C/C++.br3ak"
SECTION="general"
VERSION=17.0.0
NAME="js"

#REQ:libffi
#REQ:nspr
#REQ:python2
#REQ:zip
#OPT:doxygen


cd $SOURCE_DIR

URL=http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz

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

whoami > /tmp/currentuser

cd js/src &&
sed -i 's/(defined\((@TEMPLATE_FILE)\))/\1/' config/milestone.pl &&
./configure --prefix=/usr       \
            --enable-readline   \
            --enable-threadsafe \
            --with-system-ffi   \
            --with-system-nspr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
find /usr/include/js-17.0/            \
     /usr/lib/libmozjs-17.0.a         \
     /usr/lib/pkgconfig/mozjs-17.0.pc \
     -type f -exec chmod -v 644 {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
