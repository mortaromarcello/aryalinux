#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The libexif package contains abr3ak library for parsing, editing, and saving EXIF data. Most digitalbr3ak cameras produce EXIF files, which are JPEG files with extra tagsbr3ak that contain information about the image. All EXIF tags describedbr3ak in EXIF standard 2.1 are supported.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:doxygen
#OPT:graphviz


#VER:libexif:0.6.21


NAME="libexif"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libexif/libexif-0.6.21.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libexif/libexif-0.6.21.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libexif/libexif-0.6.21.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libexif/libexif-0.6.21.tar.bz2 || wget -nc http://downloads.sourceforge.net/libexif/libexif-0.6.21.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libexif/libexif-0.6.21.tar.bz2


URL=http://downloads.sourceforge.net/libexif/libexif-0.6.21.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --with-doc-dir=/usr/share/doc/libexif-0.6.21 \
            --disable-static &&
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
