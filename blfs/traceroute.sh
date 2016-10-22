#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:traceroute:2.1.0



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/traceroute/traceroute-2.1.0.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc http://downloads.sourceforge.net/traceroute/traceroute-2.1.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install                                 &&
mv /usr/bin/traceroute /bin                              &&
ln -sv -f traceroute /bin/traceroute6                    &&
ln -sv -f traceroute.8 /usr/share/man/man8/traceroute6.8 &&
rm -fv /usr/share/man/man1/traceroute.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "traceroute=>`date`" | sudo tee -a $INSTALLED_LIST

