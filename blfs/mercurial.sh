#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mercurial:3.8.3

#REQ:python2
#OPT:git
#OPT:gnupg
#OPT:subversion


cd $SOURCE_DIR

URL=https://www.mercurial-scm.org/release/mercurial-3.8.3.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mercurial/mercurial-3.8.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mercurial/mercurial-3.8.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mercurial/mercurial-3.8.3.tar.gz || wget -nc https://www.mercurial-scm.org/release/mercurial-3.8.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mercurial/mercurial-3.8.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mercurial/mercurial-3.8.3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make build


make doc


rm -rf tests/tmp &&
TESTFLAGS="-j<em class="replaceable"><code><N></em> --tmpdir tmp --blacklist blacklists/failed-tests" \
make check



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install-bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install-doc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat >> ~/.hgrc << "EOF"
[ui]
username = <em class="replaceable"><code><user_name> <user@mail></em>
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /etc/mercurial &&
cat >> /etc/mercurial/hgrc << "EOF"
[web]
cacerts = /etc/ssl/ca-bundle.crt
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mercurial=>`date`" | sudo tee -a $INSTALLED_LIST

