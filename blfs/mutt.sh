#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mutt:1.7.1

#OPT:aspell
#OPT:cyrus-sasl
#OPT:gdb
#OPT:gnupg
#OPT:gpgme
#OPT:libidn
#OPT:mitkrb
#OPT:slang
#OPT:openssl
#OPT:gnutls
#OPT:db
#OPT:libxslt
#OPT:lynx
#OPT:w3m
#OPT:docbook-dsssl
#OPT:openjade
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=ftp://ftp.mutt.org/pub/mutt/mutt-1.7.1.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mutt/mutt-1.7.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mutt/mutt-1.7.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mutt/mutt-1.7.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mutt/mutt-1.7.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mutt/mutt-1.7.1.tar.gz || wget -nc ftp://ftp.mutt.org/pub/mutt/mutt-1.7.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 34 mail

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chgrp -v mail /var/mail

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cp -v doc/manual.txt{,.shipped} &&
./configure --prefix=/usr                           \
            --sysconfdir=/etc                       \
            --with-docdir=/usr/share/doc/mutt-1.7.1 \
            --enable-external-dotlock               \
            --enable-pop                            \
            --enable-imap                           \
            --enable-hcache                         \
            --enable-sidebar                        &&
make &&
test -s doc/manual.txt || mv -v doc/manual.txt{.shipped,}


make -C doc manual.pdf



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 doc/manual.pdf \
    /usr/share/doc/mutt-1.7.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


chown root:mail /usr/bin/mutt_dotlock &&
chmod -v 2755 /usr/bin/mutt_dotclock


cat /usr/share/doc/mutt-1.7.1/samples/gpg.rc >> ~/.muttrc


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mutt=>`date`" | sudo tee -a $INSTALLED_LIST

