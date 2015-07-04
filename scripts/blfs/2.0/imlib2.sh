#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/enlightenment/imlib2-1.4.6.tar.bz2


TARBALL=imlib2-1.4.6.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e '/DGifOpen/s:fd:&, NULL:'           \
    -e '/DGifCloseFile/s:gif:&, NULL:'     \
    -i src/modules/loaders/loader_gif.c    &&
sed -i 's/@my_libs@//' imlib2-config.in    &&

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998794.sh << "ENDOFFILE"
make install &&
install -v -m755 -d /usr/share/doc/imlib2-1.4.6 &&
install -v -m644    doc/{*.gif,index.html} \
                    /usr/share/doc/imlib2-1.4.6
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "imlib2=>`date`" | sudo tee -a $INSTALLED_LIST