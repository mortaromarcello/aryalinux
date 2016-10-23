#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNU Scientific Library (GSL) is a numerical library for C andbr3ak C++ programmers. It provides a wide range of mathematical routinesbr3ak such as random number generators, special functions andbr3ak least-squares fitting.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:texlive
#OPT:tl-installer


#VER:gsl:2.2.1


NAME="gsl"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsl/gsl-2.2.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gsl/gsl-2.2.1.tar.gz || wget -nc ftp://ftp.gnu.org/pub/gnu/gsl/gsl-2.2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsl/gsl-2.2.1.tar.gz || wget -nc http://ftp.gnu.org/pub/gnu/gsl/gsl-2.2.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gsl/gsl-2.2.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gsl/gsl-2.2.1.tar.gz


URL=http://ftp.gnu.org/pub/gnu/gsl/gsl-2.2.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make &&
make html



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir /usr/share/doc/gsl-2.2.1 &&
cp doc/gsl-ref.html/* /usr/share/doc/gsl-2.2.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST