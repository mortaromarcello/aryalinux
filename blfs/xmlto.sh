#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The xmlto is a front-end to an XSLbr3ak toolchain. It chooses an appropriate stylesheet for the conversionbr3ak you want and applies it using an external XSL-T processor. It alsobr3ak performs any necessary post-processing.br3ak
#SECTION:pst

whoami > /tmp/currentuser

#REQ:docbook
#REQ:docbook-xsl
#REQ:libxslt
#OPT:fop
#OPT:links
#OPT:lynx
#OPT:w3m


#VER:xmlto:0.0.28


NAME="xmlto"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc https://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2


URL=https://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.28.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

LINKS="/usr/bin/links" \
./configure --prefix=/usr &&
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
