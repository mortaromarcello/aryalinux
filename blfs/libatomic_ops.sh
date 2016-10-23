#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libatomic_ops providesbr3ak implementations for atomic memory update operations on a number ofbr3ak architectures. This allows direct use of these in reasonablybr3ak portable code. Unlike earlier similar packages, this one explicitlybr3ak considers memory barrier semantics, and allows the construction ofbr3ak code that involves minimum overhead across a variety ofbr3ak architectures.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:libatomic_ops:7.4.4


NAME="libatomic_ops"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libatomic/libatomic_ops-7.4.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatomic/libatomic_ops-7.4.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatomic/libatomic_ops-7.4.4.tar.gz || wget -nc http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libatomic/libatomic_ops-7.4.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libatomic/libatomic_ops-7.4.4.tar.gz


URL=http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's#pkgdata#doc#' doc/Makefile.am &&
autoreconf -fi &&
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --docdir=/usr/share/doc/libatomic_ops-7.4.4 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v   /usr/share/libatomic_ops/* \
        /usr/share/doc/libatomic_ops-7.4.4 &&
rm -vrf /usr/share/libatomic_ops

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
