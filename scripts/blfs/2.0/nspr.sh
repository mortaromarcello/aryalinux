#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.8/src/nspr-4.10.8.tar.gz
wget -nc ftp://ftp.mozilla.org/pub/nspr/releases/v4.10.8/src/nspr-4.10.8.tar.gz


TARBALL=nspr-4.10.8.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cd nspr                                                     &&
sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in &&
sed -i 's#$(LIBRARY) ##' config/rules.mk                    &&

./configure --prefix=/usr \
            --with-mozilla \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make

cat > 1434987998763.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "nspr=>`date`" | sudo tee -a $INSTALLED_LIST