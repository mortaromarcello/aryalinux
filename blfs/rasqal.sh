#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Rasqal is a C library that handlesbr3ak Resource Description Framework (RDF) query language syntaxes, querybr3ak construction and execution of queries returning results asbr3ak bindings, boolean, RDF graphs/triples or syntaxes. It is requiredbr3ak by Soprano to build Nepomuk.br3ak"
SECTION="general"
VERSION=0.9.33
NAME="rasqal"

#REQ:raptor
#OPT:pcre
#OPT:libgcrypt


cd $SOURCE_DIR

URL=http://download.librdf.org/source/rasqal-0.9.33.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz || wget -nc http://download.librdf.org/source/rasqal-0.9.33.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
