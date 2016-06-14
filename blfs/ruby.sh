#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ruby:2.3.0

#OPT:db
#OPT:doxygen
#OPT:graphviz
#OPT:libffi
#OPT:openssl
#OPT:tk
#OPT:yaml
#OPT:valgrind


cd $SOURCE_DIR

URL=http://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ruby/ruby-2.3.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ruby/ruby-2.3.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ruby/ruby-2.3.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ruby/ruby-2.3.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ruby/ruby-2.3.0.tar.xz || wget -nc http://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr   \
            --enable-shared \
            --docdir=/usr/share/doc/ruby-2.3.0 &&
make "-j`nproc`"


make capi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ruby=>`date`" | sudo tee -a $INSTALLED_LIST

