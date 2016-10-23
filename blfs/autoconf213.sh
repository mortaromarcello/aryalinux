#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Autoconf-2.13 is an old version ofbr3ak Autoconf . This old versionbr3ak accepts switches which are not valid in more recent versions. Nowbr3ak that firefox has started to usebr3ak python2 for configuring, this oldbr3ak version is required even if configure files have not been changed.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:dejagnu


#VER:autoconf:2.13


NAME="autoconf213"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc http://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/autoconf/autoconf-2.13-consolidated_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/autoconf-2.13-consolidated_fixes-1.patch


URL=http://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../autoconf-2.13-consolidated_fixes-1.patch &&
mv -v autoconf.texi autoconf213.texi                      &&
rm -v autoconf.info                                       &&
./configure --prefix=/usr --program-suffix=2.13           &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                      &&
install -v -m644 autoconf213.info /usr/share/info &&
install-info --info-dir=/usr/share/info autoconf213.info

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
