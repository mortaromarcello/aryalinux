#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Cdrdao package contains CDbr3ak recording utilities. These are useful for burning a CD inbr3ak disk-at-once mode.br3ak"
SECTION="multimedia"
VERSION=1.2.3
NAME="cdrdao"

#REC:libao
#REC:libvorbis
#REC:libmad
#REC:lame


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/cdrdao/cdrdao-1.2.3.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cdrdao/cdrdao-1.2.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdrdao/cdrdao-1.2.3.tar.bz2 || wget -nc http://downloads.sourceforge.net/cdrdao/cdrdao-1.2.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cdrdao/cdrdao-1.2.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cdrdao/cdrdao-1.2.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdrdao/cdrdao-1.2.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i '/ioctl/a #include <sys/stat.h>' dao/ScsiIf-linux.cc    &&
sed -i 's/\(char .*REMOTE\)/unsigned \1/' dao/CdrDriver.{cc,h} &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/cdrdao-1.2.3 &&
install -v -m644 README /usr/share/doc/cdrdao-1.2.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
