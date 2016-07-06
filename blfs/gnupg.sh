#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnupg:2.1.11

#REQ:libassuan
#REQ:libgcrypt
#REQ:libksba
#REQ:npth
#REC:pinentry
#OPT:curl
#OPT:libusb-compat
#OPT:openldap
#OPT:sqlite
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.11.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnupg/gnupg-2.1.11.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnupg/gnupg-2.1.11.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnupg/gnupg-2.1.11.tar.bz2 || wget -nc https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.11.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnupg/gnupg-2.1.11.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.1.11.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnupg/gnupg-2.1.11.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's|\(GNUPGHOME\)=\$(abs_builddir)|\1=`/bin/pwd`|' \
      -i tests/openpgp/Makefile.in


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --enable-symcryptrun \
            --docdir=/usr/share/doc/gnupg-2.1.11 &&
make &&
makeinfo --html --no-split -o doc/gnupg_nochunks.html doc/gnupg.texi &&
makeinfo --plaintext       -o doc/gnupg.txt           doc/gnupg.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
for f in gpg gpgv ; do
ln -sfv ${f}2   /usr/bin/${f} &&
ln -sfv ${f}2.1 /usr/share/man/man1/${f}.1
done &&
install -v -dm755 /usr/share/doc/gnupg-2.1.11/html       &&
install -v -m644  doc/gnupg_nochunks.html \
                  /usr/share/doc/gnupg-2.1.11/gnupg.html &&
install -v -m644  doc/*.texi doc/gnupg.txt \
                  /usr/share/doc/gnupg-2.1.11

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnupg=>`date`" | sudo tee -a $INSTALLED_LIST

