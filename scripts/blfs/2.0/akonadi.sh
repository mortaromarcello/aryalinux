#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:boost
#DEP:sqlite
#DEP:mariadb
#DEP:postgresql
#DEP:shared-mime-info


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/akonadi/src/akonadi-1.13.0.tar.bz2
wget -nc ftp://ftp.kde.org/pub/kde/stable/akonadi/src/akonadi-1.13.0.tar.bz2


TARBALL=akonadi-1.13.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX  \
      -DCMAKE_BUILD_TYPE=Release          \
      -DINSTALL_QSQLITE_IN_QT_PREFIX=TRUE \
      -Wno-dev .. &&
make

cat > 1434987998797.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998797.sh
sudo ./1434987998797.sh
sudo rm -rf 1434987998797.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "akonadi=>`date`" | sudo tee -a $INSTALLED_LIST