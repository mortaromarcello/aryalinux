#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The librep package contains a Lispbr3ak system. This is useful for scripting or for applications that maybr3ak use the Lisp interpreter as an extension language.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:libffi


#VER:librep_:0.92.6


NAME="librep"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc http://download.tuxfamily.org/librep/librep_0.92.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/librep/librep_0.92.6.tar.xz


URL=http://download.tuxfamily.org/librep/librep_0.92.6.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh --prefix=/usr --disable-static &&
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
