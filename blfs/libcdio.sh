#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libcdio is a library forbr3ak CD-ROM and CD image access. The assiciated libcido-cdparanoia library reads audio frombr3ak the CD-ROM directly as data, with no analog step between, andbr3ak writes the data to a file or pipe as .wav, .aifc or as raw 16 bitbr3ak linear PCM.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:libcddb


#VER:libcdio-paranoia:10.2+0.93+1
#VER:libcdio:0.93


NAME="libcdio"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc http://ftp.gnu.org/gnu/libcdio/libcdio-0.93.tar.bz2
wget -nc http://ftp.gnu.org/gnu/libcdio/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.93+1.tar.bz2


URL=http://ftp.gnu.org/gnu/libcdio/libcdio-0.93.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../libcdio-paranoia-10.2+0.93+1.tar.bz2 &&
cd libcdio-paranoia-10.2+0.93+1
./configure --prefix=/usr --disable-static &&
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
