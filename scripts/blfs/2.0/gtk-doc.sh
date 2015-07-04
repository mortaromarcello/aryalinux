#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:docbook
#DEP:docbook-xsl
#DEP:itstool
#DEP:libxslt


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.21/gtk-doc-1.21.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.21/gtk-doc-1.21.tar.xz


TARBALL=gtk-doc-1.21.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998768.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998768.sh
sudo ./1434987998768.sh
sudo rm -rf 1434987998768.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gtk-doc=>`date`" | sudo tee -a $INSTALLED_LIST