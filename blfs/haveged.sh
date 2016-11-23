#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Haveged package contains abr3ak daemon that generates an unpredictable stream of random numbers andbr3ak feeds the /dev/random device.br3ak"
SECTION="postlfs"
VERSION=1.9.1
NAME="haveged"



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/project/haveged/haveged-1.9.1.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/haveged/haveged-1.9.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/haveged/haveged-1.9.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/haveged/haveged-1.9.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/haveged/haveged-1.9.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/haveged/haveged-1.9.1.tar.gz || wget -nc http://downloads.sourceforge.net/project/haveged/haveged-1.9.1.tar.gz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv    /usr/share/doc/haveged-1.9.1 &&
cp -v README /usr/share/doc/haveged-1.9.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-haveged

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
