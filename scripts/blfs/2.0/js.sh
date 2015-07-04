#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libffi
#DEP:nspr
#DEP:python2
#DEP:zip


cd $SOURCE_DIR

TARBALL=mozjs17.0.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz
wget -nc ftp://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz


tar -xf $TARBALL

cd $DIRECTORY

cd js/src &&
./configure --prefix=/usr       \
            --enable-readline   \
            --enable-threadsafe \
            --with-system-ffi   \
            --with-system-nspr &&
make

cat > 1434309266680.sh << ENDOFFILE
make install &&

find /usr/include/js-17.0/            \
     /usr/lib/libmozjs-17.0.a         \
     /usr/lib/pkgconfig/mozjs-17.0.pc \
     -type f -exec chmod -v 644 {} \;
ENDOFFILE
chmod a+x 1434309266680.sh
sudo ./1434309266680.sh
sudo rm -rf 1434309266680.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "js=>`date`" | sudo tee -a $INSTALLED_LIST