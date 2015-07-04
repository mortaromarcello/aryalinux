#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:python-modules#py2cairo


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.6.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.6.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/pygobject-2.28.6-fixes-1.patch


TARBALL=pygobject-2.28.6.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../pygobject-2.28.6-fixes-1.patch   &&
./configure --prefix=/usr --disable-introspection &&
make

cat > 1434987998777.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998777.sh
sudo ./1434987998777.sh
sudo rm -rf 1434987998777.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#pygobject2=>`date`" | sudo tee -a $INSTALLED_LIST