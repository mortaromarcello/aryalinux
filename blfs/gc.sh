#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GC package contains thebr3ak Boehm-Demers-Weiser conservative garbage collector, which can bebr3ak used as a garbage collecting replacement for the C malloc functionbr3ak or C++ new operator. It allows you to allocate memory basically asbr3ak you normally would, without explicitly deallocating memory that isbr3ak no longer useful. The collector automatically recycles memory whenbr3ak it determines that it can no longer be otherwise accessed. Thebr3ak collector is also used by a number of programming languagebr3ak implementations that either use C as intermediate code, want tobr3ak facilitate easier interoperation with C libraries, or just preferbr3ak the simple collector interface. Alternatively, the garbagebr3ak collector may be used as a leak detector for C or C++ programs,br3ak though that is not its primary goal.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libatomic_ops


#VER:gc:7.6.0


NAME="gc"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gc/gc-7.6.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gc/gc-7.6.0.tar.gz || wget -nc http://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gc/gc-7.6.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gc/gc-7.6.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gc/gc-7.6.0.tar.gz


URL=http://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's#pkgdata#doc#' doc/doc.am &&
autoreconf -fi  &&
./configure --prefix=/usr      \
            --enable-cplusplus \
            --disable-static   \
            --docdir=/usr/share/doc/gc-7.6.0 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 doc/gc.man /usr/share/man/man3/gc_malloc.3 &&
ln -sfv gc_malloc.3 /usr/share/man/man3/gc.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
