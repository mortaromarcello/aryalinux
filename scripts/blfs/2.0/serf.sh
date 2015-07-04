#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apr-util
#DEP:openssl
#DEP:scons


cd $SOURCE_DIR

wget -nc http://serf.googlecode.com/svn/src_releases/serf-1.3.8.tar.bz2


TARBALL=serf-1.3.8.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "/Append/s:RPATH=libdir,::"   SConstruct &&
sed -i "/Default/s:lib_static,::"    SConstruct &&
sed -i "/Alias/s:install_static,::"  SConstruct &&
scons PREFIX=/usr

sed -i test/test_buckets.c \
    -e 's://\(    buf_size = orig_len + (orig_len / 1000) + 12;\):/\*\1\ */:'

cat > 1434987998785.sh << "ENDOFFILE"
scons PREFIX=/usr install
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "serf=>`date`" | sudo tee -a $INSTALLED_LIST