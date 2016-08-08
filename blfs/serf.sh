#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:serf:1.3.8

#REQ:apr-util
#REQ:openssl
#REQ:scons
#OPT:mitkrb


cd $SOURCE_DIR

URL=https://archive.apache.org/dist/serf/serf-1.3.8.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/serf/serf-1.3.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/serf/serf-1.3.8.tar.bz2 || wget -nc https://archive.apache.org/dist/serf/serf-1.3.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/serf/serf-1.3.8.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/serf/serf-1.3.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/serf/serf-1.3.8.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/Append/s:RPATH=libdir,::"   SConstruct &&
sed -i "/Default/s:lib_static,::"    SConstruct &&
sed -i "/Alias/s:install_static,::"  SConstruct &&
scons PREFIX=/usr


sed -i test/test_buckets.c \
    -e 's://\(    buf_size = orig_len + (orig_len / 1000) + 12;\):/\*\1\ */:'



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
scons PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "serf=>`date`" | sudo tee -a $INSTALLED_LIST

