#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.2.tar.gz


TARBALL=xfsprogs-3.2.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make DEBUG=-DNDEBUG     \
     INSTALL_USER=root  \
     INSTALL_GROUP=root \
     LOCAL_CONFIGURE_OPTIONS="--enable-readline"

cat > 1434987998753.sh << "ENDOFFILE"
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-3.2.2 install     &&
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-3.2.2 install-dev &&
rm -rfv /usr/lib/libhandle.a                               &&
rm -rfv /lib/libhandle.{a,la,so}                           &&
ln -sfv ../../lib/libhandle.so.1 /usr/lib/libhandle.so     &&
sed -i "s@libdir='/lib@libdir='/usr/lib@g" /usr/lib/libhandle.la
ENDOFFILE
chmod a+x 1434987998753.sh
sudo ./1434987998753.sh
sudo rm -rf 1434987998753.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xfsprogs=>`date`" | sudo tee -a $INSTALLED_LIST