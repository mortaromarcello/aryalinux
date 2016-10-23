#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak p7zip is the Unix command-linebr3ak port of 7-Zip, a file archiver that archives with high compressionbr3ak ratios. It handles 7z, ZIP, GZIP, BZIP2, XZ, TAR, APM, ARJ, CAB,br3ak CHM, CPIO, CramFS, DEB, DMG, FAT, HFS, ISO, LZH, LZMA, LZMA2, MBR,br3ak MSI, MSLZ, NSIS, NTFS, RAR RPM, SquashFS, UDF, VHD, WIM, XAR and Zbr3ak formats.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:p7zip_src_all:_16.02


NAME="p7zip"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc http://downloads.sourceforge.net/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2


URL=http://downloads.sourceforge.net/p7zip/p7zip_16.02_src_all.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make all3



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make DEST_HOME=/usr \
     DEST_MAN=/usr/share/man \
     DEST_SHARE_DOC=/usr/share/doc/p7zip-16.02 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
