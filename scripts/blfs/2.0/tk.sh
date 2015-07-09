#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:tcl
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/tcl/tk8.6.3-src.tar.gz


TARBALL=tk8.6.3-src.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cd unix &&
./configure --prefix=/usr \
            --mandir=/usr/share/man \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&

make &&

sed -e "s@^\(TK_SRC_DIR='\).*@\1/usr/include'@" \
    -e "/TK_B/s@='\(-L\)\?.*unix@='\1/usr/lib@" \
    -i tkConfig.sh

cat > 1434987998779.sh << "ENDOFFILE"
make install &&
make install-private-headers &&
ln -sfv wish8.6 /usr/bin/wish &&
chmod -v 755 /usr/lib/libtk8.6.so
ENDOFFILE
chmod a+x 1434987998779.sh
sudo ./1434987998779.sh
sudo rm -rf 1434987998779.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tk=>`date`" | sudo tee -a $INSTALLED_LIST