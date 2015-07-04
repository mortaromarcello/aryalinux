#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2


TARBALL=slang-2.2.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --with-readline=gnu &&
make -j1

cat > 1434987998778.sh << "ENDOFFILE"
make install_doc_dir=/usr/share/doc/slang-2.2.4   \
     SLSH_DOC_DIR=/usr/share/doc/slang-2.2.4/slsh \
     install-all &&

chmod -v 755 /usr/lib/libslang.so.2.2.4 \
             /usr/lib/slang/v2/modules/*.so
ENDOFFILE
chmod a+x 1434987998778.sh
sudo ./1434987998778.sh
sudo rm -rf 1434987998778.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "slang=>`date`" | sudo tee -a $INSTALLED_LIST