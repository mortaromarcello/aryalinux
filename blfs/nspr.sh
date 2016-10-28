#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Netscape Portable Runtime (NSPR)br3ak provides a platform-neutral API for system level and libc likebr3ak functions.br3ak
#SECTION:general



#VER:nspr:4.13.1


NAME="nspr"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nspr/nspr-4.13.1.tar.gz || wget -nc https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.13.1/src/nspr-4.13.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nspr/nspr-4.13.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nspr/nspr-4.13.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nspr/nspr-4.13.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nspr/nspr-4.13.1.tar.gz


URL=https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.13.1/src/nspr-4.13.1.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

cd nspr                                                     &&
sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in &&
sed -i 's#$(LIBRARY) ##' config/rules.mk                    &&

./configure --prefix=/usr \
            --with-mozilla \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
