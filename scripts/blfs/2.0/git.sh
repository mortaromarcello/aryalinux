#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:curl
#DEP:openssl
#DEP:python2


cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/software/scm/git/git-2.3.0.tar.xz
wget -nc ftp://ftp.kernel.org/pub/software/scm/git/git-2.3.0.tar.xz


TARBALL=git-2.3.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-gitconfig=/etc/gitconfig &&
make

make html

make man

cat > 1434987998775.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

cat > 1434987998775.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-man
cd ..
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

cat > 1434987998775.sh << "ENDOFFILE"
tar -xf ../git-manpages-2.3.0.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

cat > 1434987998775.sh << "ENDOFFILE"
make htmldir=/usr/share/doc/git-2.3.0 install-html
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

cat > 1434987998775.sh << "ENDOFFILE"
mkdir -pv   /usr/share/doc/git-2.3.0                                    &&
tar   -xf   ../git-htmldocs-2.3.0.tar.xz \
      -C    /usr/share/doc/git-2.3.0 --no-same-owner --no-overwrite-dir &&

find        /usr/share/doc/git-2.3.0 -type d -exec chmod 755 {} \;      &&
find        /usr/share/doc/git-2.3.0 -type f -exec chmod 644 {} \;
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

cat > 1434987998775.sh << "ENDOFFILE"
mkdir -v /usr/share/doc/git-2.3.0/man-pages/{html,text}          &&
mv        /usr/share/doc/git-2.3.0/{git*.txt,man-pages/text}     &&
mv        /usr/share/doc/git-2.3.0/{git*.,index.,man-pages/}html &&

mkdir -v /usr/share/doc/git-2.3.0/technical/{html,text}          &&
mv        /usr/share/doc/git-2.3.0/technical/{*.txt,text}        &&
mv        /usr/share/doc/git-2.3.0/technical/{*.,}html           &&

mkdir -v /usr/share/doc/git-2.3.0/howto/{html,text}              &&
mv        /usr/share/doc/git-2.3.0/howto/{*.txt,text}            &&
mv        /usr/share/doc/git-2.3.0/howto/{*.,}html
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "git=>`date`" | sudo tee -a $INSTALLED_LIST