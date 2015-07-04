#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxml2
#DEP:gtk2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libglade/2.6/libglade-2.6.4.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libglade/2.6/libglade-2.6.4.tar.bz2


TARBALL=libglade-2.6.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/DG_DISABLE_DEPRECATED/d' glade/Makefile.in &&
./configure --prefix=/usr --disable-static &&
make

cat > 1434987998795.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libglade=>`date`" | sudo tee -a $INSTALLED_LIST