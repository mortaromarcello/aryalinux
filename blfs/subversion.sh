#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:subversion:1.9.4

#REQ:apr-util
#REQ:sqlite
#REC:serf
#OPT:apache
#OPT:cyrus-sasl
#OPT:dbus
#OPT:python2
#OPT:ruby
#OPT:swig
#OPT:openjdk
#OPT:junit


cd $SOURCE_DIR

URL=http://www.apache.org/dist/subversion/subversion-1.9.4.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2 || wget -nc http://www.apache.org/dist/subversion/subversion-1.9.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --with-apache-libexecdir &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/subversion-1.9.4 &&
cp      -v -R       doc/* \
                    /usr/share/doc/subversion-1.9.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "subversion=>`date`" | sudo tee -a $INSTALLED_LIST

