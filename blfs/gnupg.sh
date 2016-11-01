#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The GnuPG package is GNU's toolbr3ak for secure communication and data storage. It can be used tobr3ak encrypt data and to create digital signatures. It includes anbr3ak advanced key management facility and is compliant with the proposedbr3ak OpenPGP Internet standard as described in RFC2440 and the S/MIMEbr3ak standard as described by several RFCs. GnuPG 2 is the stablebr3ak version of GnuPG integrating support for OpenPGP and S/MIME.br3ak"
SECTION="postlfs"
VERSION=2.1.15
NAME="gnupg"

#REQ:libassuan
#REQ:libgcrypt
#REQ:libgpg-error
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

URL=https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.15.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.15.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnupg/gnupg-2.1.15.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.1.15.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnupg/gnupg-2.1.15.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnupg/gnupg-2.1.15.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnupg/gnupg-2.1.15.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnupg/gnupg-2.1.15.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -e 's|\(GNUPGHOME\)=\$(abs_builddir)|\1=`/bin/pwd`|' \
    -i tests/openpgp/Makefile.in


./configure --prefix=/usr \
            --enable-symcryptrun \
            --docdir=/usr/share/doc/gnupg-2.1.15 &&
make &&
makeinfo --html --no-split \
         -o doc/gnupg_nochunks.html doc/gnupg.texi &&
makeinfo --plaintext       \
         -o doc/gnupg.txt           doc/gnupg.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/gnupg-2.1.15/html            &&
install -v -m644    doc/gnupg_nochunks.html \
                    /usr/share/doc/gnupg-2.1.15/html/gnupg.html &&
install -v -m644    doc/*.texi doc/gnupg.txt \
                    /usr/share/doc/gnupg-2.1.15

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
for f in gpg gpgv
do
  ln -svf ${f}2.1 /usr/share/man/man1/$f.1 &&
  ln -svf ${f}2   /usr/bin/$f
done
unset f

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
