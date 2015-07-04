#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/non-gnu/cvs/source/stable/1.11.23/cvs-1.11.23.tar.bz2
wget -nc ftp://ftp.gnu.org/non-gnu/cvs/source/stable/1.11.23/cvs-1.11.23.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/cvs-1.11.23-zlib-1.patch


TARBALL=cvs-1.11.23.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../cvs-1.11.23-zlib-1.patch

sed -i -e 's/getline /get_line /' lib/getline.{c,h} &&
sed -i -e 's/^@sp$/& 1/'          doc/cvs.texinfo &&
touch doc/*.pdf

./configure --prefix=/usr --docdir=/usr/share/doc/cvs-1.11.23 &&
make

make -C doc html txt

sed -e 's/rsh};/ssh};/' \
    -e 's/g=rw,o=r$/g=r,o=r/' \
    -i src/sanity.sh

cat > 1434987998774.sh << "ENDOFFILE"
make install &&
make -C doc install-pdf &&
install -v -m644 FAQ README /usr/share/doc/cvs-1.11.23
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh

cat > 1434987998774.sh << "ENDOFFILE"
install -v -m644 doc/*.txt /usr/share/doc/cvs-1.11.23                   &&
install -v -m755 -d        /usr/share/doc/cvs-1.11.23/html/cvs{,client} &&
install -v -m644 doc/cvs.html/* \
                           /usr/share/doc/cvs-1.11.23/html/cvs          &&
install -v -m644 doc/cvsclient.html/* \
                           /usr/share/doc/cvs-1.11.23/html/cvsclient
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cvs=>`date`" | sudo tee -a $INSTALLED_LIST