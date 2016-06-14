#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:heirloom-mailx_.orig:12.5

#OPT:openssl
#OPT:nss
#OPT:mitkrb


cd $SOURCE_DIR

URL=http://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/downloads/heirloom-mailx/heirloom-mailx-12.5-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/heirloom-mailx-12.5-fixes-1.patch
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc ftp://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../heirloom-mailx-12.5-fixes-1.patch &&
make SENDMAIL=/usr/sbin/sendmail -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr UCBINSTALL=/usr/bin/install install &&
ln -v -sf mailx /usr/bin/mail &&
ln -v -sf mailx /usr/bin/nail &&
install -v -m755 -d /usr/share/doc/heirloom-mailx-12.5 &&
install -v -m644 README /usr/share/doc/heirloom-mailx-12.5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mailx=>`date`" | sudo tee -a $INSTALLED_LIST

