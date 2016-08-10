#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:dash:0.5.9



cd $SOURCE_DIR

URL=http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dash/dash-0.5.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dash/dash-0.5.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dash/dash-0.5.9.tar.gz || wget -nc http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dash/dash-0.5.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dash/dash-0.5.9.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --bindir=/bin --mandir=/usr/share/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


ln -svf dash /bin/sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/shells << "EOF"
/bin/dash
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "dash=>`date`" | sudo tee -a $INSTALLED_LIST

