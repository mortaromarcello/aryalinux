#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.sfr-fresh.com/unix/misc/tcsh-6.18.01.tar.gz
wget -nc ftp://ftp.astron.com/pub/tcsh/tcsh-6.18.01.tar.gz


TARBALL=tcsh-6.18.01.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e 's|\$\*|#&|' -e 's|fR/g|&m|' tcsh.man2html &&

./configure --prefix=/usr --bindir=/bin &&
make &&
sh ./tcsh.man2html

cat > 1434987998754.sh << "ENDOFFILE"
make install install.man &&
ln -v -sf tcsh   /bin/csh &&
ln -v -sf tcsh.1 /usr/share/man/man1/csh.1 &&
install -v -m755 -d          /usr/share/doc/tcsh-6.18.01/html &&
install -v -m644 tcsh.html/* /usr/share/doc/tcsh-6.18.01/html &&
install -v -m644 FAQ         /usr/share/doc/tcsh-6.18.01
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh

cat > 1434987998754.sh << "ENDOFFILE"
cat >> /etc/shells << "EOF"
/bin/tcsh
/bin/csh
EOF
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tcsh=>`date`" | sudo tee -a $INSTALLED_LIST