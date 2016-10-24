#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak Gavl is short for Gmerlin Audiobr3ak Video Library. It is a low level library that handles the detailsbr3ak of audio and video formats like colorspaces, samplerates,br3ak multichannel configurations etc. It provides standardizedbr3ak definitions for those formats as well as container structures forbr3ak carrying audio samples or video images inside an application.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:gavl:1.4.0


NAME="gavl"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc http://sourceforge.net/projects/gmerlin/files/gavl/1.4.0/gavl-1.4.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz


URL=http://sourceforge.net/projects/gmerlin/files/gavl/1.4.0/gavl-1.4.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --without-doxygen \
            --docdir=/usr/share/doc/gavl-1.4.0 &&
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
