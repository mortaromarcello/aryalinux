#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Asciidoc package is a textbr3ak document format for writing notes, documentation, articles, books,br3ak ebooks, slideshows, web pages, man pages and blogs. AsciiDoc filesbr3ak can be translated to many formats including HTML, PDF, EPUB, andbr3ak man page.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:python2
#REQ:python3


#VER:asciidoc:8.6.9


NAME="asciidoc"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc http://sourceforge.net/projects/asciidoc/files/asciidoc/8.6.9/asciidoc-8.6.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz


URL=http://sourceforge.net/projects/asciidoc/files/asciidoc/8.6.9/asciidoc-8.6.9.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/asciidoc-8.6.9 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
make docs

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
