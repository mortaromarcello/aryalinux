#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Heirloom mailx packagebr3ak (formerly known as the Nailbr3ak package) contains <span class="command"><strong>mailx</strong>, a command-line Mail Userbr3ak Agent derived from Berkeley Mail. It is intended to provide thebr3ak functionality of the POSIX <span class="command"><strong>mailx</strong> command with additionalbr3ak support for MIME messages, IMAP (including caching), POP3, SMTP,br3ak S/MIME, message threading/sorting, scoring, and filtering.br3ak Heirloom mailx is especiallybr3ak useful for writing scripts and batch processing.br3ak
#SECTION:basicnet

#OPT:openssl
#OPT:nss
#OPT:mitkrb
#OPT:mail


#VER:heirloom-mailx_.orig:12.5


NAME="mailx"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc ftp://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/heirloom-mailx-12.5-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/heirloom-mailx/heirloom-mailx-12.5-fixes-1.patch


URL=http://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../heirloom-mailx-12.5-fixes-1.patch &&
make SENDMAIL=/usr/sbin/sendmail -j1


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr UCBINSTALL=/usr/bin/install install &&
ln -v -sf mailx /usr/bin/mail &&
ln -v -sf mailx /usr/bin/nail &&
install -v -m755 -d /usr/share/doc/heirloom-mailx-12.5 &&
install -v -m644 README /usr/share/doc/heirloom-mailx-12.5
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
