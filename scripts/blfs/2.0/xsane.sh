#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2
#DEP:sane


cd $SOURCE_DIR

wget -nc http://www.xsane.org/download/xsane-0.999.tar.gz


TARBALL=xsane-0.999.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e 's/png_ptr->jmpbuf/png_jmpbuf(png_ptr)/' \
    -i src/xsane-save.c                         &&
./configure --prefix=/usr                       &&
make

cat > 1434987998841.sh << "ENDOFFILE"
make xsanedocdir=/usr/share/doc/xsane-0.999 install &&
ln -sfv ../../doc/xsane-0.999 /usr/share/sane/xsane/doc
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh

cat > 1434987998841.sh << "ENDOFFILE"
ln -sfv <browser> /usr/bin/netscape
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh

cat > 1434987998841.sh << "ENDOFFILE"
ln -sfv /usr/bin/xsane /usr/lib/gimp/2.0/plug-ins/
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xsane=>`date`" | sudo tee -a $INSTALLED_LIST