#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libffi
#DEP:python2
#DEP:python3
#DEP:pcre


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/glib/2.42/glib-2.42.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib/2.42/glib-2.42.1.tar.xz


TARBALL=glib-2.42.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-pcre=system &&
make

cat > 1434987998756.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998756.sh
sudo ./1434987998756.sh
sudo rm -rf 1434987998756.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "glib2=>`date`" | sudo tee -a $INSTALLED_LIST