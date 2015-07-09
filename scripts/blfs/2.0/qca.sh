#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:qt4
#DEP:cacerts


cd $SOURCE_DIR

wget -nc http://delta.affinix.com/download/qca/2.0/qca-2.1.0.tar.gz


TARBALL=qca-2.1.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "/BSD_SOURCE/d" CMakeLists.txt

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DQT4_BUILD=ON              \
      -DQCA_DOC_INSTALL_DIR=/usr/share/doc/qca-2.1.0            \
      -DQCA_FEATURE_INSTALL_DIR=/usr/share/qt4/mkspecs/features \
      -DQCA_INCLUDE_INSTALL_DIR=/usr/include/qt4                \
      -DQCA_PRIVATE_INCLUDE_INSTALL_DIR=/usr/include/qt4        \
      -DQCA_PLUGINS_INSTALL_DIR=/usr/lib/qt4/plugins            \
      -Wno-dev .. &&

make

cat > 1434987998764.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998764.sh
sudo ./1434987998764.sh
sudo rm -rf 1434987998764.sh

cat > 1434987998764.sh << "ENDOFFILE"
if [[ ${QT4DIR} != "/usr" ]]
then
   ln -sfv /usr/include/qt4/QtCrypto                  \
           ${QT4DIR}/include/qt4/                     &&
   ln -sfv /usr/share/qt4/mkspecs/features/crypto.prf \
           ${QT4DIR}/share/qt4/mkspecs/features/      &&

   install -v -dm755 ${QT4DIR}/lib/qt4/plugins/crypto &&

   for file in /usr/lib/qt4/plugins/crypto/*
   do
       ln -sfv ${file} ${QT4DIR}/lib/qt4/plugins/crypto/
   done &&

   unset file
fi
ENDOFFILE
chmod a+x 1434987998764.sh
sudo ./1434987998764.sh
sudo rm -rf 1434987998764.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "qca=>`date`" | sudo tee -a $INSTALLED_LIST