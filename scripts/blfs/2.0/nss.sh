#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:nspr
#DEP:sqlite


cd $SOURCE_DIR

wget -nc https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_17_4_RTM/src/nss-3.17.4.tar.gz
wget -nc ftp://ftp.mozilla.org/pub/security/nss/releases/NSS_3_17_4_RTM/src/nss-3.17.4.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/nss-3.17.4-standalone-1.patch


TARBALL=nss-3.17.4.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../nss-3.17.4-standalone-1.patch &&

cd nss &&
make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1) -j1

cat > 1434987998748.sh << "ENDOFFILE"
cd ../dist                                                       &&
install -v -m755 Linux*/lib/*.so              /usr/lib           &&
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib           &&
install -v -m755 -d                           /usr/include/nss   &&
cp -v -RL {public,private}/nss/*              /usr/include/nss   &&
chmod -v 644                                  /usr/include/nss/* &&
install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&
install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "nss=>`date`" | sudo tee -a $INSTALLED_LIST