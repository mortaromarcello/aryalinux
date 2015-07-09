#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gc
#DEP:imlib2


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/w3m/w3m-0.5.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/w3m-0.5.3-bdwgc72-1.patch


TARBALL=w3m-0.5.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../w3m-0.5.3-bdwgc72-1.patch &&
sed -i 's/file_handle/file_foo/' istream.{c,h} &&
sed -i 's#gdk-pixbuf-xlib-2.0#& x11#' configure &&

./configure --prefix=/usr --sysconfdir=/etc --with-imagelib=imlib2 &&
sed -i "s:lImlib2:& -lX11:" Makefile &&
make

cat > 1434987998785.sh << "ENDOFFILE"
make install &&
install -v -m644 -D doc/keymap.default /etc/w3m/keymap &&
install -v -m644    doc/menu.default /etc/w3m/menu &&
install -v -m755 -d /usr/share/doc/w3m-0.5.3 &&
install -v -m644    doc/{HISTORY,READ*,keymap.*,menu.*,*.html} \
                    /usr/share/doc/w3m-0.5.3
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "w3m=>`date`" | sudo tee -a $INSTALLED_LIST