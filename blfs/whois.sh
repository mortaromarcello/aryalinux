#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Whois is a client-side applicationbr3ak which queries the whois directory service for informationbr3ak pertaining to a particular domain name. This package will installbr3ak two programs by default: <span class="command"><strong>whois</strong> and <span class="command"><strong>mkpasswd</strong>. The <span class="command"><strong>mkpasswd</strong> command is alsobr3ak installed by the <a class="xref" href="../general/expect.html" br3ak title="Expect-5.45">Expect-5.45</a> package.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#OPT:libidn


#VER:whois_:5.2.12


NAME="whois"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc http://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc ftp://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.12.tar.xz


URL=http://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.12.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install-whois
make prefix=/usr install-mkpasswd
make prefix=/usr install-pos

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
