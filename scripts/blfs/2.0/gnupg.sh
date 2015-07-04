#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libassuan
#DEP:libgcrypt
#DEP:libksba
#DEP:pth
#DEP:pinentry


cd $SOURCE_DIR

wget -nc ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.26.tar.bz2


TARBALL=gnupg-2.0.26.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --enable-symcryptrun \
            --docdir=/usr/share/doc/gnupg-2.0.26 &&
make &&

makeinfo --html --no-split -o doc/gnupg_nochunks.html doc/gnupg.texi &&
makeinfo --plaintext       -o doc/gnupg.txt           doc/gnupg.texi

cat > 1434987998746.sh << "ENDOFFILE"
make install &&

for f in gpg gpgv ; do
ln -sfv ${f}2   /usr/bin/${f} &&
ln -sfv ${f}2.1 /usr/share/man/man1/${f}.1
done &&

install -v -dm755 /usr/share/doc/gnupg-2.0.26/html       &&
install -v -m644  doc/gnupg_nochunks.html \
                  /usr/share/doc/gnupg-2.0.26/gnupg.html &&
install -v -m644  doc/*.texi doc/gnupg.txt \
                  /usr/share/doc/gnupg-2.0.26
ENDOFFILE
chmod a+x 1434987998746.sh
sudo ./1434987998746.sh
sudo rm -rf 1434987998746.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnupg=>`date`" | sudo tee -a $INSTALLED_LIST