#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Network Security Services (NSS) package is a set of libraries designed tobr3ak support cross-platform development of security-enabled client andbr3ak server applications. Applications built with NSS can support SSL v2br3ak and v3, TLS, PKCS #5, PKCS #7, PKCS #11, PKCS #12, S/MIME, X.509 v3br3ak certificates, and other security standards. This is useful forbr3ak implementing SSL and S/MIME or other Internet security standardsbr3ak into an application.br3ak"
SECTION="postlfs"
VERSION=3.27.1
NAME="nss"

#REQ:nspr
#REC:sqlite


cd $SOURCE_DIR

URL=https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_27_1_RTM/src/nss-3.27.1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nss/nss-3.27.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nss/nss-3.27.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nss/nss-3.27.1.tar.gz || wget -nc https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_27_1_RTM/src/nss-3.27.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nss/nss-3.27.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nss/nss-3.27.1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/nss/nss-3.27.1-standalone-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/nss-3.27.1-standalone-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

patch -Np1 -i ../nss-3.27.1-standalone-1.patch &&
cd nss &&
make -j1 BUILD_OPT=1                  \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd ../dist                                                          &&
install -v -m755 Linux*/lib/*.so              /usr/lib              &&
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib              &&
install -v -m755 -d                           /usr/include/nss      &&
cp -v -RL {public,private}/nss/*              /usr/include/nss      &&
chmod -v 644                                  /usr/include/nss/*    &&
install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&
install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
