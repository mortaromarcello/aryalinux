#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:libgcrypt
#DEP:libtasn1
#DEP:p11-kit
#DEP:gnupg
#DEP:gobject-introspection
#DEP:gtk3
#DEP:libxslt
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gcr/3.14/gcr-3.14.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gcr/3.14/gcr-3.14.0.tar.xz


TARBALL=gcr-3.14.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998813.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998813.sh
sudo ./1434987998813.sh
sudo rm -rf 1434987998813.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gcr=>`date`" | sudo tee -a $INSTALLED_LIST