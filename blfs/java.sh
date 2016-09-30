#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:OpenJDK-1.8.0.92-i-bin:686
#VER:OpenJDK-1.8.0.102-x-bin:86_64

#REQ:alsa-lib
#REQ:cups
#REQ:giflib
#REQ:x7lib


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-1.8.0.102/OpenJDK-1.8.0.92-i686-bin.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/OpenJDK-1.8.0.102-x86_64-bin.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-1.8.0.102-x86_64-bin.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-1.8.0.102-x86_64-bin.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/OpenJDK-1.8.0.102-x86_64-bin.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjdk/OpenJDK-1.8.0.102-x86_64-bin.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-1.8.0.102/OpenJDK-1.8.0.102-x86_64-bin.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-1.8.0.92-i686-bin.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-1.8.0.92-i686-bin.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-1.8.0.102/OpenJDK-1.8.0.92-i686-bin.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/OpenJDK-1.8.0.92-i686-bin.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/OpenJDK-1.8.0.92-i686-bin.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjdk/OpenJDK-1.8.0.92-i686-bin.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /opt/OpenJDK-1.8.0.102-bin &&
mv -v * /opt/OpenJDK-1.8.0.102-bin         &&
chown -R root:root /opt/OpenJDK-1.8.0.102-bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sfn OpenJDK-1.8.0.102-bin /opt/jdk

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "java=>`date`" | sudo tee -a $INSTALLED_LIST

