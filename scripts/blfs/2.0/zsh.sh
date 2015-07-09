#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.zsh.org/pub/zsh-5.0.7.tar.bz2


TARBALL=zsh-5.0.7.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar --strip-components=1 -xvf ../zsh-5.0.7-doc.tar.bz2

./configure --prefix=/usr         \
            --bindir=/bin         \
            --sysconfdir=/etc/zsh \
            --enable-etcdir=/etc/zsh                  &&
make                                                  &&

makeinfo  Doc/zsh.texi --plaintext -o Doc/zsh.txt     &&
makeinfo  Doc/zsh.texi --html      -o Doc/html        &&
makeinfo  Doc/zsh.texi --html --no-split --no-headers -o Doc/zsh.html

texi2pdf  Doc/zsh.texi -o Doc/zsh.pdf

cat > 1434987998755.sh << "ENDOFFILE"
make install                              &&
make infodir=/usr/share/info install.info &&

install -v -m755 -d                 /usr/share/doc/zsh-5.0.7/html &&
install -v -m644 Doc/html/*         /usr/share/doc/zsh-5.0.7/html &&
install -v -m644 Doc/zsh.{html,txt} /usr/share/doc/zsh-5.0.7
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
make htmldir=/usr/share/doc/zsh-5.0.7/html install.html &&
install -v -m644 Doc/zsh.dvi /usr/share/doc/zsh-5.0.7
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
install -v -m644 Doc/zsh.pdf /usr/share/doc/zsh-5.0.7
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
mv -v /usr/lib/libpcre.so.* /lib &&
ln -v -sf ../../lib/libpcre.so.0 /usr/lib/libpcre.so

mv -v /usr/lib/libgdbm.so.* /lib &&
ln -v -sf ../../lib/libgdbm.so.3 /usr/lib/libgdbm.so
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
cat >> /etc/shells << "EOF"
/bin/zsh
/bin/zsh-5.0.7
EOF
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "zsh=>`date`" | sudo tee -a $INSTALLED_LIST