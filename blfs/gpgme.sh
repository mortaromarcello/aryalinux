#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GPGME package is a C librarybr3ak that allows cryptography support to be added to a program. It isbr3ak designed to make access to public key crypto engines likebr3ak GnuPG or GpgSM easier forbr3ak applications. GPGME provides abr3ak high-level crypto API for encryption, decryption, signing,br3ak signature verification and key management.br3ak
#SECTION:postlfs

#REQ:libassuan
#OPT:doxygen
#OPT:gnupg
#OPT:clisp
#OPT:python2
#OPT:python3
#OPT:qt5
#OPT:swig


#VER:gpgme:1.7.1


NAME="gpgme"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpgme/gpgme-1.7.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gpgme/gpgme-1.7.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gpgme/gpgme-1.7.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gpgme/gpgme-1.7.1.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.7.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpgme/gpgme-1.7.1.tar.bz2


URL=ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.7.1.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
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
