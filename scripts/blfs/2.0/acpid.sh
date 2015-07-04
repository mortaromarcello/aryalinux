#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/acpid2/acpid-2.0.23.tar.xz


TARBALL=acpid-2.0.23.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --docdir=/usr/share/doc/acpid-2.0.23 &&
make

cat > 1434987998770.sh << "ENDOFFILE"
make install                         &&
install -v -m755 -d /etc/acpi/events &&
cp -r samples /usr/share/doc/acpid-2.0.23
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
cat > /etc/acpi/events/lid << "EOF"
event=button/lid
action=/etc/acpi/lid.sh
EOF

cat > /etc/acpi/lid.sh << "EOF"
#!/bin/sh
/bin/grep -q open /proc/acpi/button/lid/LID/state && exit 0
/usr/sbin/pm-suspend
EOF
chmod -v 755 /etc/acpi/lid.sh
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-acpid
cd ..
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "acpid=>`date`" | sudo tee -a $INSTALLED_LIST