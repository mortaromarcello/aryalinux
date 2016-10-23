#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Libsndfile is a library of Cbr3ak routines for reading and writing files containing sampled audiobr3ak data.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:alsa-lib
#OPT:flac
#OPT:libogg
#OPT:libvorbis
#OPT:sqlite


#VER:libsndfile:1.0.27


NAME="libsndfile"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsndfile/libsndfile-1.0.27.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsndfile/libsndfile-1.0.27.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsndfile/libsndfile-1.0.27.tar.gz || wget -nc http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.27.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsndfile/libsndfile-1.0.27.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsndfile/libsndfile-1.0.27.tar.gz


URL=http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.27.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libsndfile-1.0.27 &&
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