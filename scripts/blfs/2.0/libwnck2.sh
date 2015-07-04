#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2
#DEP:startup-notification


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz


TARBALL=libwnck-2.30.7.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --disable-static \
            --program-suffix=-1 &&
make GETTEXT_PACKAGE=libwnck-1

cat > 1434987998823.sh << "ENDOFFILE"
make GETTEXT_PACKAGE=libwnck-1 install
ENDOFFILE
chmod a+x 1434987998823.sh
sudo ./1434987998823.sh
sudo rm -rf 1434987998823.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libwnck2=>`date`" | sudo tee -a $INSTALLED_LIST