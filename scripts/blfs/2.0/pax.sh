#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/heirloom/heirloom-070715.tar.bz2


TARBALL=heirloom-070715.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i build/mk.config                   \
    -e '/LIBZ/s@ -Wl[^ ]*@@g'            \
    -e '/LIBBZ2/{s@^#@@;s@ -Wl[^ ]*@@g}' \
    -e '/BZLIB/s@0@1@'                   &&
make makefiles                           &&
make -C libcommon                        &&
make -C libuxre                          &&
make -C cpio

cat > 1434987998772.sh << "ENDOFFILE"
install -v -m755 cpio/pax_su3 /usr/bin/pax &&
install -v -m644 cpio/pax.1 /usr/share/man/man1
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pax=>`date`" | sudo tee -a $INSTALLED_LIST