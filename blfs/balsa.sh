#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Balsa package contains abr3ak GNOME-2 based mail client.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:aspell
#REQ:enchant
#REQ:gmime
#REQ:libesmtp
#REQ:rarian
#REC:pcre
#OPT:compface
#OPT:gtksourceview
#OPT:libnotify
#OPT:mitkrb
#OPT:openldap
#OPT:openssl
#OPT:sqlite
#OPT:webkitgtk
#OPT:gpgme


#VER:balsa:2.5.2


NAME="balsa"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://pawsa.fedorapeople.org/balsa/balsa-2.5.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/balsa/balsa-2.5.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/balsa/balsa-2.5.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/balsa/balsa-2.5.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/balsa/balsa-2.5.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/balsa/balsa-2.5.2.tar.bz2


URL=http://pawsa.fedorapeople.org/balsa/balsa-2.5.2.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --with-rubrica           \
            --without-html-widget    \
            --without-libnotify      \
            --without-gtkspell       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
