#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The LAME package contains an MP3br3ak encoder and optionally, an MP3 frame analyzer. This is useful forbr3ak creating and analyzing compressed audio files.br3ak"
SECTION="multimedia"
VERSION=3.99.5
NAME="lame"

#OPT:libsndfile
#OPT:nasm


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lame/lame-3.99.5.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lame/lame-3.99.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lame/lame-3.99.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lame/lame-3.99.5.tar.gz || wget -nc http://downloads.sourceforge.net/lame/lame-3.99.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lame/lame-3.99.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lame/lame-3.99.5.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

case $(uname -m) in
   i?86) sed -i -e '/xmmintrin\.h/d' configure ;;
esac


./configure --prefix=/usr --enable-mp3rtp --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make pkghtmldir=/usr/share/doc/lame-3.99.5 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
