#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apr-util
#DEP:sqlite
#DEP:serf


cd $SOURCE_DIR

wget -nc http://www.apache.org/dist/subversion/subversion-1.8.11.tar.bz2


TARBALL=subversion-1.8.11.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --with-apache-libexecdir &&
make

sed -i 's#Makefile.PL.in$#& libsvn_swig_perl#' Makefile.in

make javahl

make swig-pl

make swig-py \
     swig_pydir=/usr/lib/python2.7/site-packages/libsvn \
     swig_pydir_extra=/usr/lib/python2.7/site-packages/svn

make swig-rb

cat > 1434987998778.sh << "ENDOFFILE"
make -j1 install &&
install -v -dm755 /usr/share/doc/subversion-1.8.11 &&
cp      -rv       doc/* \
                  /usr/share/doc/subversion-1.8.11
ENDOFFILE
chmod a+x 1434987998778.sh
sudo ./1434987998778.sh
sudo rm -rf 1434987998778.sh

cat > 1434987998778.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-javahl
cd ..
ENDOFFILE
chmod a+x 1434987998778.sh
sudo ./1434987998778.sh
sudo rm -rf 1434987998778.sh

cat > 1434987998778.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-swig-pl
cd ..
ENDOFFILE
chmod a+x 1434987998778.sh
sudo ./1434987998778.sh
sudo rm -rf 1434987998778.sh

cat > 1434987998778.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-swig-py \
     swig_pydir=/usr/lib/python2.7/site-packages/libsvn \
     swig_pydir_extra=/usr/lib/python2.7/site-packages/svn
cd ..
ENDOFFILE
chmod a+x 1434987998778.sh
sudo ./1434987998778.sh
sudo rm -rf 1434987998778.sh

cat > 1434987998778.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-swig-rb
cd ..
ENDOFFILE
chmod a+x 1434987998778.sh
sudo ./1434987998778.sh
sudo rm -rf 1434987998778.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "subversion=>`date`" | sudo tee -a $INSTALLED_LIST