#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Wireless Extension (WE) is a generic API in the Linux kernelbr3ak allowing a driver to expose configuration and statistics specificbr3ak to common Wireless LANs to user space. A single set of tools canbr3ak support all the variations of Wireless LANs, regardless of theirbr3ak type as long as the driver supports Wireless Extensions. WEbr3ak parameters may also be changed on the fly without restarting thebr3ak driver (or Linux).br3ak
#SECTION:basicnet

whoami > /tmp/currentuser



#VER:wireless_tools.:29


NAME="wireless_tools"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/wireless_tools-29-fix_iwlist_scanning-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/wireless_tools/wireless_tools-29-fix_iwlist_scanning-1.patch


URL=http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch


make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr INSTALL_MAN=/usr/share/man install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
