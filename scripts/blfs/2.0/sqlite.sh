#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://sqlite.org/2015/sqlite-autoconf-3080802.tar.gz
wget -nc https://sqlite.org/2015/sqlite-doc-3080802.zip


TARBALL=sqlite-autoconf-3080802.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

unzip -q ../sqlite-doc-3080802.zip

./configure --prefix=/usr --disable-static        \
            CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 \
            -DSQLITE_ENABLE_COLUMN_METADATA=1     \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1       \
            -DSQLITE_SECURE_DELETE=1" &&
make

cat > 1434987998788.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
install -v -m755 -d /usr/share/doc/sqlite-3.8.8.2 &&
cp -v -R sqlite-doc-3080802/* /usr/share/doc/sqlite-3.8.8.2
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sqlite=>`date`" | sudo tee -a $INSTALLED_LIST