#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The LXDM is a lightweight Displaybr3ak Manager for the LXDE desktop. Itbr3ak can also be used as an alternative to other Display Managers suchbr3ak as GNOME's GDM or LightDM.br3ak"
SECTION="x"
VERSION=0.5.3
NAME="lxdm"

#REQ:gtk2
#REQ:iso-codes
#REQ:librsvg
#REC:linux-pam
#OPT:gtk3


wget -nc http://downloads.sourceforge.net/lxdm/lxdm-0.5.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz


URL=http://downloads.sourceforge.net/lxdm/lxdm-0.5.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

cat > pam/lxdm << "EOF" &&
#%PAM-1.0
auth required pam_unix.so
auth requisite pam_nologin.so
account required pam_unix.so
password required pam_unix.so
session required pam_unix.so
EOF
sed -i 's:sysconfig/i18n:profile.d/i18n.sh:g' data/lxdm.in &&
sed -i 's:/etc/xprofile:/etc/profile:g' data/Xsession &&
sed -e 's/^bg/#&/'        \
    -e '/reset=1/ s/# //' \
    -e 's/logou$/logout/' \
    -e "/arg=/a arg=$XORG_PREFIX/bin/X" \
    -i data/lxdm.conf.in


./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-pam        &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-lxdm

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
