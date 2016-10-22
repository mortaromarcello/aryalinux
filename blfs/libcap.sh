#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libcap:2.25

#REQ:linux-pam


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc ftp://ftp.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcap/libcap-2.25.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make -C pam_cap



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 pam_cap/pam_cap.so /lib/security &&
install -v -m644 pam_cap/capability.conf /etc/security

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libcap=>`date`" | sudo tee -a $INSTALLED_LIST

