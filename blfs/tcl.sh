#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Tcl package contains the Toolbr3ak Command Language, a robust general-purpose scripting language.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:tcl-html:8.6.6
#VER:tcl-src:8.6.6


NAME="tcl"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/tcl/tcl8.6.6-src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.6-src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tcl/tcl8.6.6-src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcl/tcl8.6.6-src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcl/tcl8.6.6-src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.6-src.tar.gz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcl/tcl8.6.6-html.tar.gz || wget -nc http://downloads.sourceforge.net/tcl/tcl8.6.6-html.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.6-html.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcl/tcl8.6.6-html.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.6-html.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tcl/tcl8.6.6-html.tar.gz


URL=http://downloads.sourceforge.net/tcl/tcl8.6.6-src.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../tcl8.6.6-html.tar.gz --strip-components=1


export SRCDIR=`pwd` &&
cd unix &&
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make &&
sed -e "s#$SRCDIR/unix#/usr/lib#" \
    -e "s#$SRCDIR#/usr/include#"  \
    -i tclConfig.sh               &&
sed -e "s#$SRCDIR/unix/pkgs/tdbc1.0.4#/usr/lib/tdbc1.0.4#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.4/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/tdbc1.0.4/library#/usr/lib/tcl8.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.4#/usr/include#"            \
    -i pkgs/tdbc1.0.4/tdbcConfig.sh                        &&
sed -e "s#$SRCDIR/unix/pkgs/itcl4.0.5#/usr/lib/itcl4.0.5#" \
    -e "s#$SRCDIR/pkgs/itcl4.0.5/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/itcl4.0.5#/usr/include#"            \
    -i pkgs/itcl4.0.5/itclConfig.sh                        &&
unset SRCDIR



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
make install-private-headers &&
ln -v -sf tclsh8.6 /usr/bin/tclsh &&
chmod -v 755 /usr/lib/libtcl8.6.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -v -p /usr/share/doc/tcl-8.6.6 &&
cp -v -r  ../html/* /usr/share/doc/tcl-8.6.6

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
