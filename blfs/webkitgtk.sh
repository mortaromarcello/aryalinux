#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:webkitgtk:2.10.7

#REQ:cmake
#REQ:gst10-plugins-base
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
#REC:gtk2
#REC:hicolor-icon-theme
#OPT:gtk-doc
#OPT:harfbuzz
#OPT:libnotify
#OPT:llvm


cd $SOURCE_DIR

URL=http://webkitgtk.org/releases/webkitgtk-2.10.7.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/webkit/webkitgtk-2.10.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/webkit/webkitgtk-2.10.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/webkit/webkitgtk-2.10.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/webkit/webkitgtk-2.10.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/webkit/webkitgtk-2.10.7.tar.xz || wget -nc http://webkitgtk.org/releases/webkitgtk-2.10.7.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "s#isnan#std::&#g" Source/JavaScriptCore/runtime/Options.cpp

mkdir build &&
cd    build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON       \
      -DPORT=GTK                  \
      -DLIB_INSTALL_DIR=/usr/lib  \
      -DUSE_LIBHYPHEN=OFF         \
      -DENABLE_MINIBROWSER=ON     \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -vdm755 /usr/share/gtk-doc/html/webkit{2,dom}gtk-4.0 &&
install -vm644 ../Documentation/webkit2gtk-4.0/html/*  \
               /usr/share/gtk-doc/html/webkit2gtk-4.0        &&
install -vm644 ../Documentation/webkitdomgtk-4.0/html/* \
               /usr/share/gtk-doc/html/webkitdomgtk-4.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "webkitgtk=>`date`" | sudo tee -a $INSTALLED_LIST

