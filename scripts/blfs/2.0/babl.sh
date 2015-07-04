#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://download.gimp.org/pub/babl/0.1/babl-0.1.12.tar.bz2


TARBALL=babl-0.1.12.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998765.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/gtk-doc/html/babl/graphics &&
install -v -m644 docs/*.{css,html} /usr/share/gtk-doc/html/babl &&
install -v -m644 docs/graphics/*.{html,png,svg} /usr/share/gtk-doc/html/babl/graphics
ENDOFFILE
chmod a+x 1434987998765.sh
sudo ./1434987998765.sh
sudo rm -rf 1434987998765.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "babl=>`date`" | sudo tee -a $INSTALLED_LIST