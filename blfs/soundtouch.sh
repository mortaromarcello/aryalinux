#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The SoundTouch package contains anbr3ak open-source audio processing library that allows changing the soundbr3ak tempo, pitch and playback rate parameters independently from eachbr3ak other.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:soundtouch:1.9.2


NAME="soundtouch"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc http://www.surina.net/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz


URL=http://www.surina.net/soundtouch/soundtouch-1.9.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./bootstrap &&
./configure --prefix=/usr \
            --docdir=/usr/share/doc/soundtouch-1.9.2 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST