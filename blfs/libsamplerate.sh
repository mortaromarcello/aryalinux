#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak libsamplerate is a sample ratebr3ak converter for audio.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:libsndfile


#VER:libsamplerate:0.1.9


NAME="libsamplerate"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://www.mega-nerd.com/SRC/libsamplerate-0.1.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsamplerate/libsamplerate-0.1.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsamplerate/libsamplerate-0.1.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsamplerate/libsamplerate-0.1.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsamplerate/libsamplerate-0.1.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsamplerate/libsamplerate-0.1.9.tar.gz


URL=http://www.mega-nerd.com/SRC/libsamplerate-0.1.9.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make htmldocdir=/usr/share/doc/libsamplerate-0.1.9 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
