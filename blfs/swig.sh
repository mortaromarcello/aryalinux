#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak SWIG (Simplified Wrapper andbr3ak Interface Generator) is a compiler that integrates C and C++br3ak with languages including Perl,br3ak Python, Tcl, Ruby,br3ak PHP, Java, C#,br3ak D, Go, Lua,br3ak Octave, R, Scheme,br3ak Ocaml, Modula-3, Commonbr3ak Lisp, and Pike.br3ak SWIG can also export its parsebr3ak tree into Lisp s-expressions andbr3ak XML.br3ak
#SECTION:general

#REQ:pcre
#OPT:boost


#VER:swig:3.0.10


NAME="swig"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/swig/swig-3.0.10.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/swig/swig-3.0.10.tar.gz || wget -nc http://downloads.sourceforge.net/swig/swig-3.0.10.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/swig/swig-3.0.10.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/swig/swig-3.0.10.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/swig/swig-3.0.10.tar.gz


URL=http://downloads.sourceforge.net/swig/swig-3.0.10.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr                      \
            --without-clisp                    \
            --without-maximum-compile-warnings &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/swig-3.0.10 &&
cp -v -R Doc/* /usr/share/doc/swig-3.0.10
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
