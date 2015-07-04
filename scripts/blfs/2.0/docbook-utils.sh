#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openjade
#DEP:docbook-dsssl
#DEP:sgml-dtd-3


cd $SOURCE_DIR

wget -nc ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/docbook-utils-0.6.14-grep_fix-1.patch


TARBALL=docbook-utils-0.6.14.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../docbook-utils-0.6.14-grep_fix-1.patch &&
sed -i 's:/html::' doc/HTML/Makefile.in                &&

./configure --prefix=/usr --mandir=/usr/share/man      &&
make

cat > 1434987998842.sh << "ENDOFFILE"
make docdir=/usr/share/doc install
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
for doctype in html ps dvi man pdf rtf tex texi txt
do
    ln -svf docbook2$doctype /usr/bin/db2$doctype
done
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "docbook-utils=>`date`" | sudo tee -a $INSTALLED_LIST