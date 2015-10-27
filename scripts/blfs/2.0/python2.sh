#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libffi


cd $SOURCE_DIR

wget -nc https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/Python-2.7.9-skip_test_gdb-1.patch
wget -nc https://docs.python.org/ftp/python/doc/2.7.9/python-2.7.9-docs-html.tar.bz2


TARBALL=Python-2.7.9.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../Python-2.7.9-skip_test_gdb-1.patch

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --enable-unicode=ucs4 &&
make

cat > 1434987998776.sh << "ENDOFFILE"
make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
install -v -dm755 /usr/share/doc/python-2.7.9 &&
tar --strip-components=1 -C /usr/share/doc/python-2.7.9 \
    --no-same-owner -xvf ../python-2.7.9-docs-html.tar.bz2      &&
find /usr/share/doc/python-2.7.9 -type d -exec chmod 0755 {} \; &&
find /usr/share/doc/python-2.7.9 -type f -exec chmod 0644 {} \;
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
export PYTHONDOCS=/usr/share/doc/python-2.7.9
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python2=>`date`" | sudo tee -a $INSTALLED_LIST