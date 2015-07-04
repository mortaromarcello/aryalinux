#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:sdl
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://pkgs.fedoraproject.org/repo/pkgs/agg/agg-2.5.tar.gz/0229a488bc47be10a2fee6cf0b2febd6/agg-2.5.tar.gz


TARBALL=agg-2.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's:  -L@x_libraries@::' src/platform/X11/Makefile.am &&
sed -i '/^AM_C_PROTOTYPES/d'   configure.in                 &&

bash autogen.sh --prefix=/usr --disable-static &&
make

cat > 1434987998792.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998792.sh
sudo ./1434987998792.sh
sudo rm -rf 1434987998792.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "agg=>`date`" | sudo tee -a $INSTALLED_LIST