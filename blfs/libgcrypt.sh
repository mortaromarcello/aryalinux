#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libgcrypt package contains abr3ak general purpose crypto library based on the code used inbr3ak GnuPG. The library provides a highbr3ak level interface to cryptographic building blocks using anbr3ak extendable and flexible API.br3ak
#SECTION:general

#REQ:libgpg-error
#OPT:libcap
#OPT:pth
#OPT:texlive
#OPT:tl-installer


#VER:libgcrypt:1.7.3


NAME="libgcrypt"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2


URL=ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.3.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make

make -C doc pdf ps html &&
makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi &&
makeinfo --plaintext       -o doc/gcrypt.txt           doc/gcrypt.texi


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755   /usr/share/doc/libgcrypt-1.7.3 &&
install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                    /usr/share/doc/libgcrypt-1.7.3
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755   /usr/share/doc/libgcrypt-1.7.3/html &&
install -v -m644 doc/gcrypt.html/* \
                    /usr/share/doc/libgcrypt-1.7.3/html &&
install -v -m644 doc/gcrypt_nochunks.html \
                    /usr/share/doc/libgcrypt-1.7.3 &&
install -v -m644 doc/gcrypt.{pdf,ps,dvi,txt,texi} \
                    /usr/share/doc/libgcrypt-1.7.3
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
