#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libtheora is a referencebr3ak implementation of the Theora video compression format beingbr3ak developed by the Xiph.Org Foundation.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:libogg
#REC:libvorbis
#OPT:sdl
#OPT:libpng
#OPT:doxygen
#OPT:texlive
#OPT:tl-installer
#OPT:valgrind


#VER:libtheora:1.1.1


NAME="libtheora"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz


URL=http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd examples/.libs &&
for E in *; do
  install -v -m755 $E /usr/bin/theora_${E}
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST