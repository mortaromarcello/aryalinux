#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libdrm provides a user spacebr3ak library for accessing the DRM, direct rendering manager, onbr3ak operating systems that support the ioctl interface. libdrm is abr3ak low-level library, typically used by graphics drivers such as thebr3ak Mesa DRI drivers, the X drivers, libva and similar projects.br3ak"
SECTION="x"
VERSION=2.4.71
NAME="libdrm"

#REC:x7lib
#OPT:cairo
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:valgrind


cd $SOURCE_DIR

URL=http://dri.freedesktop.org/libdrm/libdrm-2.4.71.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc http://dri.freedesktop.org/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdrm/libdrm-2.4.71.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i "/pthread-stubs/d" configure.ac  &&
autoreconf -fiv                         &&
./configure --prefix=/usr --enable-udev &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
