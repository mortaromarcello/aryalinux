#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak SANE is short for Scanner Accessbr3ak Now Easy. Scanner access; however, is far from easy, since everybr3ak vendor has their own protocols. The only known protocol that shouldbr3ak bring some unity into this chaos is the TWAIN interface, but thisbr3ak is too imprecise to allow a stable scanning framework. Therefore,br3ak SANE comes with its own protocol,br3ak and the vendor drivers can't be used.br3ak
#SECTION:pst

#OPT:avahi
#OPT:cups
#OPT:libjpeg
#OPT:libtiff
#OPT:libusb
#OPT:v4l-utils
#OPT:texlive
#OPT:tl-installer
#OPT:installing
#OPT:gtk2
#OPT:gimp


#VER:sane-frontends:1.0.14
#VER:sane-backends:1.0.25


NAME="sane"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz || wget -nc http://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz || wget -nc http://alioth.debian.org/frs/download.php/file/1140/sane-frontends-1.0.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz


URL=http://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

groupadd -g 70 scanner

su $(whoami)

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --with-group=scanner \
            --with-docdir=/usr/share/doc/sane-backend-1.0.25 &&
make

sed -i -e 's/Jul 31 07:52:48 2013/Oct 19 13:25:20 2015/'  \
       -e 's/1.0.24git/1.0.25/'                           \
       testsuite/tools/data/db.ref                        \
       testsuite/tools/data/html-mfgs.ref                 \
       testsuite/tools/data/usermap.ref                   \
       testsuite/tools/data/html-backends-split.ref       \
       testsuite/tools/data/udev+acl.ref                  \
       testsuite/tools/data/udev.ref


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                         &&
install -m 644 -v tools/udev/libsane.rules           \
                  /etc/udev/rules.d/65-scanner.rules &&
chgrp -v scanner  /var/lock/sane
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i -e "/SANE_CAP_ALWAYS_SETTABLE/d" src/gtkglue.c &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 doc/sane.png xscanimage-icon-48x48-2.png \
    /usr/share/sane
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -s ../../../../bin/xscanimage /usr/lib/gimp/2.0/plug-ins
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/sane.d/net.conf << "EOF"
connect_timeout = 60
<server_ip>
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/{applications,pixmaps}               &&

cat > /usr/share/applications/xscanimage.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=XScanImage - Scanning
Comment=Acquire images from a scanner
Exec=xscanimage
Icon=xscanimage
Terminal=false
Type=Application
Categories=Application;Graphics
EOF

ln -svf ../sane/xscanimage-icon-48x48-2.png /usr/share/pixmaps/xscanimage.png
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
