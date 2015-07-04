#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://fossies.org/linux/misc//sane-backends-1.0.24.tar.gz
wget -nc http://alioth.debian.org/frs/download.php/file/1140/sane-frontends-1.0.14.tar.gz
wget -nc ftp://ftp2.sane-project.org/pub/sane/sane-frontends-1.0.14.tar.gz


TARBALL=sane-backends-1.0.24.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

groupadd -g 70 scanner

sed -i "s:systemd-daemon:systemd:g" configure configure.in

./configure --prefix=/usr                                    \
            --sysconfdir=/etc                                \
            --localstatedir=/var                             \
            --with-docdir=/usr/share/doc/sane-backend-1.0.24 \
            --with-group=scanner                             &&
make                                                         &&
exit

sed -i -e 's/Jul 31 07:52:48/Oct  7 08:58:33/'      \
       -e 's/1.0.24git/1.0.24/'                     \
       testsuite/tools/data/db.ref                  \
       testsuite/tools/data/html-mfgs.ref           \
       testsuite/tools/data/usermap.ref             \
       testsuite/tools/data/html-backends-split.ref \
       testsuite/tools/data/udev+acl.ref            \
       testsuite/tools/data/udev.ref

cat > 1434987998840.sh << "ENDOFFILE"
make install                                        &&
install -v -m644 tools/udev/libsane.rules           \
                 /etc/udev/rules.d/65-scanner.rules &&
chgrp -v scanner /var/lock/sane
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

sed -i -e "/SANE_CAP_ALWAYS_SETTABLE/d" src/gtkglue.c &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make

cat > 1434987998840.sh << "ENDOFFILE"
make install &&
install -v -m644 doc/sane.png xscanimage-icon-48x48-2.png \
    /usr/share/sane
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
ln -sfv ../../../../bin/xscanimage /usr/lib/gimp/2.0/plug-ins
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
cat >> /etc/sane.d/net.conf << "EOF"
connect_timeout = 60
<server_ip>
EOF
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
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

ln -sfv ../sane/xscanimage-icon-48x48-2.png /usr/share/pixmaps/xscanimage.png
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sane=>`date`" | sudo tee -a $INSTALLED_LIST