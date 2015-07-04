#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:gtk3
#DEP:libpcap


cd $SOURCE_DIR

wget -nc http://www.wireshark.org/download/src/all-versions/wireshark-1.12.3.tar.bz2
wget -nc ftp://ftp.uni-kl.de/pub/wireshark/src/wireshark-1.12.3.tar.bz2


TARBALL=wireshark-1.12.3.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > svnversion.h << "EOF"
#define SVNVERSION "BLFS"
#define SVNPATH "source"
EOF

cat > make-version.pl << "EOF"
#!/usr/bin/perl
EOF

cat > 1434987998783.sh << "ENDOFFILE"
groupadd -g 62 wireshark
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

cat > 1434987998783.sh << "ENDOFFILE"
usermod -a -G wireshark <em class="replaceable"><code><username></em>
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

sed -i "s:moc;:moc-qt5;:g" configure &&
sed -i "s:uic;:uic-qt5;:g" configure &&
sed -i "s:(AM_V_RCC)rcc:&-qt5:g" ui/qt/Makefile.in

sed -i "s:Qt5 Qt:Qt:g" configure     &&
sed -i "s:moc;:moc-qt4;:g" configure &&
sed -i "s:uic;:uic-qt4;:g" configure &&
sed -i "s:(AM_V_RCC)rcc:&-qt4:g" ui/qt/Makefile.in

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-gtk3       \
            --without-qt      &&
make

cat > 1434987998783.sh << "ENDOFFILE"
make install &&

install -v -dm755 /usr/share/doc/wireshark-1.12.3 &&
install -v -m644  README{,.linux} doc/README.* doc/*.{pod,txt} \
                  /usr/share/doc/wireshark-1.12.3 &&

pushd /usr/share/doc/wireshark-1.12.3 &&
   for FILENAME in ../../wireshark/*.html; do
      ln -sfv $FILENAME
   done &&
popd &&

if [ -e /usr/bin/wireshark ]; then
   install -v -Dm644 wireshark.desktop /usr/share/applications/wireshark.desktop
fi &&

if [ -e /usr/bin/wireshark-qt ]; then
   install -v -Dm644 wireshark.desktop /usr/share/applications/wireshark-qt.desktop &&
   sed -i "s:Exec.*wireshark:&-qt:g" /usr/share/applications/wireshark-qt.desktop   &&
   sed -i "s:Name.*Wireshark:& (Qt):g" /usr/share/applications/wireshark-qt.desktop
fi &&

for size in 16 24 32 48 64 128 256 ; do
    install -v -Dm644 image/wsicon${size}.png \
                      /usr/share/icons/hicolor/${size}x${size}/apps/wireshark.png &&
    install -v -Dm644 image/WiresharkDoc-${size}.png \
                      /usr/share/icons/hicolor/${size}x${size}/mimetypes/application-vnd.tcpdump.pcap.png
done &&

unset size
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

cat > 1434987998783.sh << "ENDOFFILE"
install -v -m644 <em class="replaceable"><code><Downloaded_Files></em> /usr/share/doc/wireshark-1.12.3
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

cat > 1434987998783.sh << "ENDOFFILE"
chown -v root:wireshark /usr/bin/{tshark,dumpcap} &&
chmod -v 6550 /usr/bin/{tshark,dumpcap}
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

cat > 1434987998783.sh << "ENDOFFILE"
usermod -a -G wireshark <username>
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "wireshark=>`date`" | sudo tee -a $INSTALLED_LIST