#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak JS is Mozilla's JavaScript enginebr3ak written in C/C++.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libffi
#REQ:nspr
#REQ:python2
#REQ:zip
#OPT:doxygen


#VER:mozjs:17.0.0


NAME="js"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz


URL=http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

cd js/src &&
sed -i 's/(defined\((@TEMPLATE_FILE)\))/\1/' config/milestone.pl &&
./configure --prefix=/usr       \
            --enable-readline   \
            --enable-threadsafe \
            --with-system-ffi   \
            --with-system-nspr &&
make "-j`nproc`"



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




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST