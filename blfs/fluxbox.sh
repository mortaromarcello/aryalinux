#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Fluxbox package contains abr3ak window manager.br3ak"
SECTION="x"
VERSION=1.3.7
NAME="fluxbox"

#REQ:xorg-server
#OPT:dbus
#OPT:fribidi
#OPT:imlib2


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/fluxbox/fluxbox-1.3.7.tar.xz

if [ ! -z $URL ]
then
wget -nc http://downloads.sourceforge.net/fluxbox/fluxbox-1.3.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fluxbox/fluxbox-1.3.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fluxbox/fluxbox-1.3.7.tar.xz || wget -nc ftp://ftp.jaist.ac.jp/pub//sourceforge/f/fl/fluxbox/fluxbox/1.3.7/fluxbox-1.3.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fluxbox/fluxbox-1.3.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fluxbox/fluxbox-1.3.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fluxbox/fluxbox-1.3.7.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


echo startfluxbox > ~/.xinitrc


cat > /usr/share/xsessions/fluxbox.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Fluxbox
Comment=This session logs you into Fluxbox
Exec=startfluxbox
Type=Application
EOF


mkdir -pv ~/.fluxbox &&
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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
