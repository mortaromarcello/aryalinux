#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libburn is a library for writingbr3ak preformatted data onto optical media: CD, DVD and BD (Blu-Ray).br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:libburn:1.4.6


NAME="libburn"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz || wget -nc http://files.libburnia-project.org/releases/libburn-1.4.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz


URL=http://files.libburnia-project.org/releases/libburn-1.4.6.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
