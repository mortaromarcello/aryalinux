#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libidn is a package designed forbr3ak internationalized string handling based on the <a class="ulink" br3ak href="http://www.ietf.org/rfc/rfc3454.txt">Stringprep</a>,br3ak <a class="ulink" href="http://www.ietf.org/rfc/rfc3492.txt">Punycode</a> and <a class="ulink" href="http://www.ietf.org/rfc/rfc3490.txt">IDNA</a>br3ak specifications defined by the Internet Engineering Task Forcebr3ak (IETF) Internationalized Domain Names (IDN) working group, used forbr3ak internationalized domain names. This is useful for converting databr3ak from the system's native representation into UTF-8, transformingbr3ak Unicode strings into ASCII strings, allowing applications to usebr3ak certain ASCII name labels (beginning with a special prefix) tobr3ak represent non-ASCII name labels, and converting entire domain namesbr3ak to and from the ASCII Compatible Encoding (ACE) form.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:pth
#OPT:emacs
#OPT:gtk-doc
#OPT:openjdk
#OPT:valgrind


#VER:libidn:1.33


NAME="libidn"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libidn/libidn-1.33.tar.gz


URL=http://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
find doc -name "Makefile*" -delete            &&
rm -rf -v doc/{gdoc,idn.1,stamp-vti,man,texi} &&
mkdir -v       /usr/share/doc/libidn-1.33     &&
cp -r -v doc/* /usr/share/doc/libidn-1.33

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
