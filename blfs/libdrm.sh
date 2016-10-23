#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libdrm provides a user spacebr3ak library for accessing the DRM, direct rendering manager, onbr3ak operating systems that support the ioctl interface. libdrm is abr3ak low-level library, typically used by graphics drivers such as thebr3ak Mesa DRI drivers, the X drivers, libva and similar projects.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REC:x7lib
#OPT:cairo
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:valgrind


#VER:libdrm:2.4.71


NAME="libdrm"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc http://dri.freedesktop.org/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2


URL=http://dri.freedesktop.org/libdrm/libdrm-2.4.71.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/pthread-stubs/d" configure.ac  &&
autoreconf -fiv                         &&
./configure --prefix=/usr --enable-udev &&
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
