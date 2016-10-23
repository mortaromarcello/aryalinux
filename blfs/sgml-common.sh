#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The SGML Common package containsbr3ak <span class="command"><strong>install-catalog</strong>. Thisbr3ak is useful for creating and maintaining centralized SGML catalogs.br3ak
#SECTION:pst

whoami > /tmp/currentuser



#VER:sgml-common:0.6.3


NAME="sgml-common"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz
wget -nc http://www.linuxfromscratch.org/patches/downloads/sgml-common/sgml-common-0.6.3-manpage-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/sgml-common-0.6.3-manpage-1.patch


URL=ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../sgml-common-0.6.3-manpage-1.patch &&
autoreconf -f -i


./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc install &&
install-catalog --add /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&
install-catalog --add /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install-catalog --remove /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&
install-catalog --remove /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
