#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/cracklib/cracklib-2.9.2.tar.gz
wget -nc http://downloads.sourceforge.net/cracklib/cracklib-words-20080507.gz


TARBALL=cracklib-2.9.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/skipping/d' util/packer.c &&

./configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/lib/cracklib/pw_dict &&
make

cat > 1434987998745.sh << "ENDOFFILE"
make install                      &&
mv -v /usr/lib/libcrack.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libcrack.so) /usr/lib/libcrack.so
ENDOFFILE
chmod a+x 1434987998745.sh
sudo ./1434987998745.sh
sudo rm -rf 1434987998745.sh

cat > 1434987998745.sh << "ENDOFFILE"
install -v -m644 -D    ../cracklib-words-20080507.gz \
                         /usr/share/dict/cracklib-words.gz     &&

gunzip -v                /usr/share/dict/cracklib-words.gz     &&
ln -v -sf cracklib-words /usr/share/dict/words                 &&
echo $(hostname) >>      /usr/share/dict/cracklib-extra-words  &&
install -v -m755 -d      /lib/cracklib                         &&

create-cracklib-dict     /usr/share/dict/cracklib-words \
                         /usr/share/dict/cracklib-extra-words
ENDOFFILE
chmod a+x 1434987998745.sh
sudo ./1434987998745.sh
sudo rm -rf 1434987998745.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cracklib=>`date`" | sudo tee -a $INSTALLED_LIST