#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#VER:xfsprogs:4.5.0



cd $SOURCE_DIR

URL=ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.5.0.tar.gz

wget -nc ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.5.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfsprogs/xfsprogs-4.5.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfsprogs/xfsprogs-4.5.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfsprogs/xfsprogs-4.5.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfsprogs/xfsprogs-4.5.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfsprogs/xfsprogs-4.5.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make DEBUG=-DNDEBUG     \
     INSTALL_USER=root  \
     INSTALL_GROUP=root \
     LOCAL_CONFIGURE_OPTIONS="--enable-readline"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-4.5.0 install     &&
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-4.5.0 install-dev &&
rm -rfv /usr/lib/libhandle.a                               &&
rm -rfv /lib/libhandle.{a,la,so}                           &&
ln -sfv ../../lib/libhandle.so.1 /usr/lib/libhandle.so     &&
sed -i "s@libdir='/lib@libdir='/usr/lib@" /usr/lib/libhandle.la

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xfsprogs=>`date`" | sudo tee -a $INSTALLED_LIST

