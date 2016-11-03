#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Whois is a client-side applicationbr3ak which queries the whois directory service for informationbr3ak pertaining to a particular domain name. This package will installbr3ak two programs by default: <span class=\"command\"><strong>whois</strong> and <span class=\"command\"><strong>mkpasswd</strong>. The <span class=\"command\"><strong>mkpasswd</strong> command is alsobr3ak installed by the <a class=\"xref\" href=\"../general/expect.html\" br3ak title=\"Expect-5.45\">Expect-5.45</a> package.br3ak"
SECTION="basicnet"
VERSION=5.2.12
NAME="whois"

#OPT:libidn


cd $SOURCE_DIR

URL=http://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.12.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc http://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/whois/whois_5.2.12.tar.xz || wget -nc ftp://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.12.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
