#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:installing


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/fluxbox/fluxbox-1.3.7.tar.xz
wget -nc ftp://ftp.jaist.ac.jp/pub//sourceforge/f/fl/fluxbox/fluxbox/1.3.7/fluxbox-1.3.7.tar.xz


TARBALL=fluxbox-1.3.7.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998796.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998796.sh
sudo ./1434987998796.sh
sudo rm -rf 1434987998796.sh

echo startfluxbox > ~/.xinitrc

cat > /usr/share/xsessions/fluxbox.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Fluxbox
Comment=This session logs you into Fluxbox
Exec=startfluxbox
Type=Application
EOF

mkdir -v ~/.fluxbox &&
cp -v /usr/share/fluxbox/init ~/.fluxbox/init &&
cp -v /usr/share/fluxbox/keys ~/.fluxbox/keys

cd ~/.fluxbox &&
fluxbox-generate_menu <em class="replaceable"><code><user_options></em>

cp -v /usr/share/fluxbox/menu ~/.fluxbox/menu

cp /usr/share/fluxbox/styles/<theme> ~/.fluxbox/theme &&

sed -i 's,\(session.styleFile:\).*,\1 ~/.fluxbox/theme,' ~/.fluxbox/init &&

[ -f ~/.fluxbox/theme ] &&
echo "background.pixmap: </path/to/nice/image.ext>" >> ~/.fluxbox/theme ||
[ -d ~/.fluxbox/theme ] &&
echo "background.pixmap: </path/to/nice/image.ext>" >> ~/.fluxbox/theme/theme.cfg


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "fluxbox=>`date`" | sudo tee -a $INSTALLED_LIST