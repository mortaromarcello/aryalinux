#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.36.tar.bz2


TARBALL=pcre-8.36.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr                     \
            --docdir=/usr/share/doc/pcre-8.36 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static                 &&
make

cat > 1434987998763.sh << "ENDOFFILE"
make install                     &&
mv -v /usr/lib/libpcre.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pcre=>`date`" | sudo tee -a $INSTALLED_LIST