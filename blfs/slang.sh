#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:slang:2.2.4

#OPT:libpng
#OPT:pcre


cd $SOURCE_DIR

URL=ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/slang/slang-2.2.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/slang/slang-2.2.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/slang/slang-2.2.4.tar.bz2 || wget -nc ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/slang/slang-2.2.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/slang/slang-2.2.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --with-readline=gnu &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install_doc_dir=/usr/share/doc/slang-2.2.4   \
     SLSH_DOC_DIR=/usr/share/doc/slang-2.2.4/slsh \
     install-all &&
chmod -v 755 /usr/lib/libslang.so.2.2.4 \
             /usr/lib/slang/v2/modules/*.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "slang=>`date`" | sudo tee -a $INSTALLED_LIST

