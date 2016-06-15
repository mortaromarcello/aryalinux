#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:nss:3.23

#REQ:nspr
#REC:sqlite


cd $SOURCE_DIR

URL=https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_23_RTM/src/nss-3.23.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/downloads/nss/nss-3.23-standalone-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/nss-3.23-standalone-1.patch
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nss/nss-3.23.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nss/nss-3.23.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nss/nss-3.23.tar.gz || wget -nc https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_23_RTM/src/nss-3.23.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nss/nss-3.23.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nss/nss-3.23.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../nss-3.23-standalone-1.patch &&
cd nss &&
make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1) -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd ../dist                                                       &&
install -v -m755 Linux*/lib/*.so              /usr/lib           &&
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib           &&
install -v -m755 -d                           /usr/include/nss   &&
cp -v -RL {public,private}/nss/*              /usr/include/nss   &&
chmod -v 644                                  /usr/include/nss/* &&
install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&
install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "nss=>`date`" | sudo tee -a $INSTALLED_LIST

