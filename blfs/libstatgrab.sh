#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak This is a library that provides cross platform access to statisticsbr3ak about the system on which it's run. It's written in C and presentsbr3ak a selection of useful interfaces which can be used to access keybr3ak system statistics. The current list of statistics includes CPUbr3ak usage, memory utilisation, disk usage, process counts, networkbr3ak traffic, disk I/O, and more.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:libstatgrab:0.91


NAME="libstatgrab"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc ftp://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz


URL=http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr   \
            --disable-static \
            --docdir=/usr/share/doc/libstatgrab-0.91 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
