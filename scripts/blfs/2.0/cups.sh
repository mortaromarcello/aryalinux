#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gnutls
#DEP:colord
#DEP:dbus
#DEP:libusb


cd $SOURCE_DIR

wget -nc http://www.cups.org/software/2.0.2/cups-2.0.2-source.tar.bz2


TARBALL=cups-2.0.2-source.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998840.sh << "ENDOFFILE"
useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
groupadd -g 19 lpadmin
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

sed -i 's#@CUPS_HTMLVIEW@#firefox#' desktop/cups.desktop.in

sed -i "s:555:755:g;s:444:644:g" Makedefs.in                 &&
sed -i "/MAN.*.EXT/s:.gz::g" config-scripts/cups-manpages.m4 &&
sed -i "/LIBGCRYPTCONFIG/d" config-scripts/cups-ssl.m4       &&

aclocal  -I config-scripts &&
autoconf -I config-scripts &&

./configure --libdir=/usr/lib            \
            --with-rcdir=/tmp/cupsinit   \
            --with-system-groups=lpadmin \
            --with-docdir=/usr/share/cups/doc-2.0.2 &&
make

cat > 1434987998840.sh << "ENDOFFILE"
make install &&
rm -rf /tmp/cupsinit &&
ln -sfv ../cups/doc-2.0.2 /usr/share/doc/cups-2.0.2
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
echo "ServerName /var/run/cups/cups.sock" > /etc/cups/client.conf
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
rm -rf /usr/share/cups/banners &&
rm -rf /usr/share/cups/data/testprint
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
gtk-update-icon-cache
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
cat > /etc/pam.d/cups << "EOF"
# Begin /etc/pam.d/cups

auth include system-auth
account include system-account
session include system-session

# End /etc/pam.d/cups
EOF
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
systemctl enable org.cups.cupsd
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cups=>`date`" | sudo tee -a $INSTALLED_LIST