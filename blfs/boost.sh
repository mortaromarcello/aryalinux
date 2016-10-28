#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Boost provides a set of freebr3ak peer-reviewed portable C++ source libraries. It includes librariesbr3ak for linear algebra, pseudorandom number generation, multithreading,br3ak image processing, regular expressions and unit testing.br3ak
#SECTION:general

#REC:general_which
#OPT:icu
#OPT:python2
#OPT:python3


#VER:boost_:1_62_0


NAME="boost"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/boost/boost_1_62_0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/boost/boost_1_62_0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/boost/boost_1_62_0.tar.bz2 || wget -nc http://downloads.sourceforge.net/project/boost/boost/1.62.0/boost_1_62_0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/boost/boost_1_62_0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/boost/boost_1_62_0.tar.bz2


URL=http://downloads.sourceforge.net/project/boost/boost/1.62.0/boost_1_62_0.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -e '/using python/ s@;@: /usr/include/python${PYTHON_VERSION/3*/${PYTHON_VERSION}m} ;@' \
    -i bootstrap.sh

sed -e '1 i#ifndef Q_MOC_RUN' \
    -e '$ a#endif'            \
    -i boost/type_traits/detail/has_binary_operator.hpp &&

./bootstrap.sh --prefix=/usr &&
./b2 stage threading=multi link=shared


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./b2 install threading=multi link=shared
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
