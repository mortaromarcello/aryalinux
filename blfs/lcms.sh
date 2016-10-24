#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Little CMS library is used bybr3ak other programs to provide color management facilities.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:libtiff
#OPT:libjpeg
#OPT:python2
#OPT:swig


#VER:lcms:1.19


NAME="lcms"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/lcms-1.19-cve_2013_4276-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/lcms/lcms-1.19-cve_2013_4276-1.patch


URL=http://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../lcms-1.19-cve_2013_4276-1.patch &&
./configure --prefix=/usr --disable-static       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/lcms-1.19 &&
install -v -m644    README.1ST doc/* \
                    /usr/share/doc/lcms-1.19

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
