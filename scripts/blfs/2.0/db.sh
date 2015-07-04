#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://download.oracle.com/berkeley-db/db-6.1.19.tar.gz


TARBALL=db-6.1.19.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cd build_unix                        &&
../dist/configure --prefix=/usr      \
                  --enable-compat185 \
                  --enable-dbm       \
                  --disable-static   \
                  --enable-cxx       &&
make

cat > 1434987998787.sh << "ENDOFFILE"
make docdir=/usr/share/doc/db-6.1.19 install &&
chown -v -R root:root                        \
      /usr/bin/db_*                          \
      /usr/include/db{,_185,_cxx}.h          \
      /usr/lib/libdb*.{so,la}                \
      /usr/share/doc/db-6.1.19
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "db=>`date`" | sudo tee -a $INSTALLED_LIST