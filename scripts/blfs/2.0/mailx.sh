#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz
wget -nc ftp://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/heirloom-mailx-12.5-fixes-1.patch


TARBALL=heirloom-mailx_12.5.orig.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../heirloom-mailx-12.5-fixes-1.patch &&
make SENDMAIL=/usr/sbin/sendmail -j1

cat > 1434987998785.sh << "ENDOFFILE"
make PREFIX=/usr UCBINSTALL=/usr/bin/install install &&
ln -v -sf mailx /usr/bin/mail &&
ln -v -sf mailx /usr/bin/nail &&
install -v -m755 -d /usr/share/doc/heirloom-mailx-12.5 &&
install -v -m644 README /usr/share/doc/heirloom-mailx-12.5
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mailx=>`date`" | sudo tee -a $INSTALLED_LIST