#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Serf package contains abr3ak C-based HTTP client library built upon the Apache Portable Runtimebr3ak (APR) library. It multiplexes connections, running the read/writebr3ak communication asynchronously. Memory copies and transformations arebr3ak kept to a minimum to provide high performance operation.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REQ:apr-util
#REQ:openssl
#REQ:scons
#OPT:mitkrb


#VER:serf:1.3.9


NAME="serf"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/serf/serf-1.3.9.tar.bz2


URL=https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/Append/s:RPATH=libdir,::"   SConstruct &&
sed -i "/Default/s:lib_static,::"    SConstruct &&
sed -i "/Alias/s:install_static,::"  SConstruct &&
scons PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
scons PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
