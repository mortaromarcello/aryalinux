#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Apache Portable Runtime Utility Library provides a predictablebr3ak and consistent interface to underlying client library interfaces.br3ak This application programming interface assures predictable if notbr3ak identical behaviour regardless of which libraries are available onbr3ak a given platform.br3ak"
SECTION="general"
VERSION=1.5.4
NAME="apr-util"

#REQ:apr
#REC:openssl
#OPT:db
#OPT:mariadb
#OPT:openldap
#OPT:postgresql
#OPT:sqlite
#OPT:unixodbc


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/apr-util/apr-util-1.5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/apr-util/apr-util-1.5.4.tar.bz2 || wget -nc http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/apr-util/apr-util-1.5.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/apr-util/apr-util-1.5.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/apr-util/apr-util-1.5.4.tar.bz2 || wget -nc ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-util-1.5.4.tar.bz2


URL=http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr       \
            --with-apr=/usr     \
            --with-gdbm=/usr    \
            --with-openssl=/usr \
            --with-crypto &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
