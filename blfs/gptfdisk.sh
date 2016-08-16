#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gptfdisk:1.0.1

#OPT:popt
#OPT:icu


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.1/gptfdisk-1.0.1.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc http://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.1/gptfdisk-1.0.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/gptfdisk-1.0.1-convenience-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/gptfdisk/gptfdisk-1.0.1-convenience-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../gptfdisk-1.0.1-convenience-1.patch &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gptfdisk=>`date`" | sudo tee -a $INSTALLED_LIST

