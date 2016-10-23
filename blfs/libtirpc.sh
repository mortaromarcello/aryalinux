#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libtirpc package containsbr3ak libraries that support programs that use the Remote Procedure Callbr3ak (RPC) API. It replaces the RPC, but not the NIS library entriesbr3ak that used to be in glibc.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#OPT:mitkrb


#VER:libtirpc:1.0.1


NAME="libtirpc"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2 || wget -nc http://downloads.sourceforge.net/project/libtirpc/libtirpc/1.0.1/libtirpc-1.0.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2


URL=http://downloads.sourceforge.net/project/libtirpc/libtirpc/1.0.1/libtirpc-1.0.1.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --disable-gssapi  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /usr/lib/libtirpc.so.* /lib &&
ln -sfv ../../lib/libtirpc.so.3.0.0 /usr/lib/libtirpc.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
