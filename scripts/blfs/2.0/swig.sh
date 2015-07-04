#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:pcre


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/swig/swig-3.0.5.tar.gz


TARBALL=swig-3.0.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e 's/"\.")/"_")/' -i Source/Modules/go.cxx

./configure --prefix=/usr                      \
            --without-clisp                    \
            --without-maximum-compile-warnings &&
make

cat > 1434987998779.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/doc/swig-3.0.5 &&
cp -rv Doc/* /usr/share/doc/swig-3.0.5
ENDOFFILE
chmod a+x 1434987998779.sh
sudo ./1434987998779.sh
sudo rm -rf 1434987998779.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "swig=>`date`" | sudo tee -a $INSTALLED_LIST