#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The gptfdisk package is a set ofbr3ak programs for creation and maintenance of GUID Partition Table (GPT)br3ak disk drives. A GPT partitioned disk is required for drives greaterbr3ak than 2 TB and is a modern replacement for legacy PC-BIOSbr3ak partitioned disk drives that use a Master Boot Record (MBR). Thebr3ak main program, <span class="command"><strong>gdisk</strong>,br3ak has an inteface similar to the classic <span class="command"><strong>fdisk</strong> program.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#OPT:popt
#OPT:icu


#VER:gptfdisk:1.0.1


NAME="gptfdisk"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gptfdisk/gptfdisk-1.0.1.tar.gz || wget -nc http://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.1/gptfdisk-1.0.1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/gptfdisk/gptfdisk-1.0.1-convenience-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/gptfdisk-1.0.1-convenience-1.patch


URL=http://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.1/gptfdisk-1.0.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../gptfdisk-1.0.1-convenience-1.patch &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
