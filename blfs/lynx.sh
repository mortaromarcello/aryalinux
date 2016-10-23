#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Lynx is a text based web browser.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#OPT:openssl
#OPT:gnutls
#OPT:zip
#OPT:unzip
#OPT:sharutils


#VER:lynx2.8.8rel:.2


NAME="lynx"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc ftp://lynx.isc.org/lynx/tarballs/lynx2.8.8rel.2.tar.bz2


URL=ftp://lynx.isc.org/lynx/tarballs/lynx2.8.8rel.2.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr          \
            --sysconfdir=/etc/lynx \
            --datadir=/usr/share/doc/lynx-2.8.8rel.2 \
            --with-zlib            \
            --with-bzlib           \
            --with-screen=ncursesw \
            --enable-locale-charset &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install-full &&
chgrp -v -R root /usr/share/doc/lynx-2.8.8rel.2/lynx_doc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#LOCALE/     a LOCALE_CHARSET:TRUE'     \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#DEFAULT_ED/ a DEFAULT_EDITOR:vi'       \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#PERSIST/    a PERSISTENT_COOKIES:TRUE' \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
