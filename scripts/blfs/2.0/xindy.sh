#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clisp
#DEP:texlive


cd $SOURCE_DIR

wget -nc http://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz


TARBALL=xindy-2.5.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

./configure --prefix=/opt/texlive/2014              \
            --bindir=/opt/texlive/2014/bin/$TEXARCH \
            --datarootdir=/opt/texlive/2014         \
            --includedir=/usr/include               \
            --libdir=/opt/texlive/2014/texmf-dist   \
            --mandir=/opt/texlive/2014/texmf-dist/doc/man &&
make LC_ALL=POSIX

cat > 1434987998844.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998844.sh
sudo ./1434987998844.sh
sudo rm -rf 1434987998844.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xindy=>`date`" | sudo tee -a $INSTALLED_LIST