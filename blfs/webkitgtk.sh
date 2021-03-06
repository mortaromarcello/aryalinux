#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The WebKitGTK+ package is a portbr3ak of the portable web rendering engine WebKit to the GTK+br3ak 3 and GTK+ 2 platforms.br3ak"
SECTION="x"
VERSION=2.14.0
NAME="webkitgtk"

#REQ:cairo
#REQ:cmake
#REQ:gst10-plugins-base
#REQ:gtk2
#REQ:gtk3
#REQ:icu
#REQ:libgudev
#REQ:libsecret
#REQ:libsoup
#REQ:libwebp
#REQ:mesa
#REQ:ruby
#REQ:sqlite
#REQ:general_which
#REC:enchant
#REC:geoclue2
#REC:geoclue
#REC:gobject-introspection
#REC:hicolor-icon-theme
#OPT:gtk-doc
#OPT:harfbuzz
#OPT:libnotify
#OPT:llvm
#OPT:wayland


cd $SOURCE_DIR

URL=http://webkitgtk.org/releases/webkitgtk-2.14.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/webkit/webkitgtk-2.14.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/webkit/webkitgtk-2.14.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/webkit/webkitgtk-2.14.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/webkit/webkitgtk-2.14.0.tar.xz || wget -nc http://webkitgtk.org/releases/webkitgtk-2.14.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/webkit/webkitgtk-2.14.0.tar.xz

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

mkdir -vp build &&
cd        build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON       \
      -DPORT=GTK                  \
      -DLIB_INSTALL_DIR=/usr/lib  \
      -DUSE_LIBHYPHEN=OFF         \
      -DENABLE_MINIBROWSER=ON     \
      -Wno-dev .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -vdm755 /usr/share/gtk-doc/html/webkit{2,dom}gtk-4.0 &&
install -vm644  ../Documentation/webkit2gtk-4.0/html/*   \
                /usr/share/gtk-doc/html/webkit2gtk-4.0       &&
install -vm644  ../Documentation/webkitdomgtk-4.0/html/* \
                /usr/share/gtk-doc/html/webkitdomgtk-4.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
