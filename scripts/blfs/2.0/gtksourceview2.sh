#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz


TARBALL=gtksourceview-2.10.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998825.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998825.sh
sudo ./1434987998825.sh
sudo rm -rf 1434987998825.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gtksourceview2=>`date`" | sudo tee -a $INSTALLED_LIST