#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libffi


cd $SOURCE_DIR

wget -nc http://www.python.org/ftp/python/3.4.2/Python-3.4.2.tar.xz
wget -nc http://docs.python.org/3/archives/python-3.4.3-docs-html.tar.bz2


TARBALL=Python-3.4.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --without-ensurepip &&
make

cat > 1434987998777.sh << "ENDOFFILE"
make install &&
chmod -v 755 /usr/lib/libpython3.4m.so &&
chmod -v 755 /usr/lib/libpython3.so
ENDOFFILE
chmod a+x 1434987998777.sh
sudo ./1434987998777.sh
sudo rm -rf 1434987998777.sh

cat > 1434987998777.sh << "ENDOFFILE"
install -v -dm755 /usr/share/doc/python-3.4.3/html &&
tar --strip-components=1 \
    --no-same-owner \
    --no-same-permissions \
    -C /usr/share/doc/python-3.4.3/html \
    -xvf ../python-3.4.3-docs-html.tar.bz2
ENDOFFILE
chmod a+x 1434987998777.sh
sudo ./1434987998777.sh
sudo rm -rf 1434987998777.sh

cat > 1434987998777.sh << "ENDOFFILE"
export PYTHONDOCS=/usr/share/doc/python-3.4.2/html
ENDOFFILE
chmod a+x 1434987998777.sh
sudo ./1434987998777.sh
sudo rm -rf 1434987998777.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python3=>`date`" | sudo tee -a $INSTALLED_LIST