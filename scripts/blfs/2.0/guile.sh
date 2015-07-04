#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gc
#DEP:libffi
#DEP:libunistring


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/pub/gnu/guile/guile-2.0.11.tar.xz
wget -nc ftp://ftp.gnu.org/pub/gnu/guile/guile-2.0.11.tar.xz


TARBALL=guile-2.0.11.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/guile-2.0.11 &&
make      &&
make html &&

makeinfo --plaintext -o doc/r5rs/r5rs.txt doc/r5rs/r5rs.texi &&
makeinfo --plaintext -o doc/ref/guile.txt doc/ref/guile.texi

cat > 1434987998776.sh << "ENDOFFILE"
make install      &&
make install-html &&

mv /usr/lib/libguile-*-gdb.scm /usr/share/gdb/auto-load/usr/lib &&
mv /usr/share/doc/guile-2.0.11/{guile.html,ref} &&
mv /usr/share/doc/guile-2.0.11/r5rs{.html,}     &&

find examples -name "Makefile*" -delete         &&
cp -vR examples   /usr/share/doc/guile-2.0.11   &&

for DIRNAME in r5rs ref; do
  install -v -m644  doc/${DIRNAME}/*.txt \
                    /usr/share/doc/guile-2.0.11/${DIRNAME}
done &&
unset DIRNAME
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "guile=>`date`" | sudo tee -a $INSTALLED_LIST