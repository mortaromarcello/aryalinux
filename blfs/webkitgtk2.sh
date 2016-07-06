#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:webkitgtk:2.4.9

#REQ:gst10-plugins-base
#REQ:gtk3
#REQ:gtk2
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
#OPT:llvm


cd $SOURCE_DIR

URL=http://webkitgtk.org/releases/webkitgtk-2.4.9.tar.xz

wget -nc http://webkitgtk.org/releases/webkitgtk-2.4.9.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/webkit/webkitgtk-2.4.9.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/webkit/webkitgtk-2.4.9.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/webkit/webkitgtk-2.4.9.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/webkit/webkitgtk-2.4.9.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/webkit/webkitgtk-2.4.9.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/generate-gtkdoc --rebase/s:^:# :' GNUmakefile.in


mkdir build3 &&
pushd build3 &&
../configure --prefix=/usr --enable-introspection &&
make &&
popd


mkdir build2 &&
pushd build2 &&
../configure --prefix=/usr --with-gtk=2.0 --disable-webkit2 &&
make &&
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C build3 install                             &&
rm -rf /usr/share/gtk-doc/html/webkit{,dom}gtk-3.0 &&
if [ -e /usr/share/gtk-doc/html/webkitdomgtk ]; then
  mv -v /usr/share/gtk-doc/html/webkitdomgtk{,-3.0}
fi
if [ -e /usr/share/gtk-doc/html/webkitgtk ]; then
  mv -v /usr/share/gtk-doc/html/webkitgtk{,-3.0}
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C build2 install                             &&
rm -rf /usr/share/gtk-doc/html/webkit{,dom}gtk-1.0 &&
if [ -e /usr/share/gtk-doc/html/webkitdomgtk ]; then
  mv -v /usr/share/gtk-doc/html/webkitdomgtk{,-1.0}
fi
if [ -e /usr/share/gtk-doc/html/webkitgtk ]; then
  mv -v /usr/share/gtk-doc/html/webkitgtk{,-1.0}
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "webkitgtk2=>`date`" | sudo tee -a $INSTALLED_LIST

