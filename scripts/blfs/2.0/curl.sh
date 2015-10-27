#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cacerts
#DEP:openssl
#DEP:gnutls


cd $SOURCE_DIR

wget -nc http://curl.haxx.se/download/curl-7.40.0.tar.lzma


TARBALL=curl-7.40.0.tar.lzma
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr              \
            --disable-static           \
            --enable-threaded-resolver &&
make

cat >> tests/data/DISABLED << "EOF"
564
700
701
703
706
707
708
709
710
711
712
EOF

cat > 1434987998784.sh << "ENDOFFILE"
make install &&
find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&
install -v -d -m755 /usr/share/doc/curl-7.40.0 &&
cp -v -R docs/*     /usr/share/doc/curl-7.40.0
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "curl=>`date`" | sudo tee -a $INSTALLED_LIST