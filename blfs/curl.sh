#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:curl:7.50.3

#REC:cacerts
#REC:openssl
#REC:gnutls
#OPT:libidn
#OPT:mitkrb
#OPT:nghttp2
#OPT:openldap
#OPT:samba
#OPT:stunnel
#OPT:valgrind


cd $SOURCE_DIR

URL=https://curl.haxx.se/download/curl-7.50.3.tar.lzma

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/curl/curl-7.50.3.tar.lzma || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/curl/curl-7.50.3.tar.lzma || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/curl/curl-7.50.3.tar.lzma || wget -nc https://curl.haxx.se/download/curl-7.50.3.tar.lzma || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/curl/curl-7.50.3.tar.lzma || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/curl/curl-7.50.3.tar.lzma

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr              \
            --disable-static           \
            --enable-threaded-resolver &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
rm -rf docs/examples/.deps &&
find docs \( -name Makefile\* \
          -o -name \*.1       \
          -o -name \*.3 \)    \
          -exec rm {} \;      &&
install -v -d -m755 /usr/share/doc/curl-7.50.3 &&
cp -v -R docs/*     /usr/share/doc/curl-7.50.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "curl=>`date`" | sudo tee -a $INSTALLED_LIST

