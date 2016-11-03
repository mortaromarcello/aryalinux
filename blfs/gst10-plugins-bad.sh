#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GStreamer Bad Plug-ins packagebr3ak contains a set of plug-ins that aren't up to par compared to thebr3ak rest. They might be close to being good quality, but they'rebr3ak missing something - be it a good code review, some documentation, abr3ak set of tests, a real live maintainer, or some actual wide use.br3ak"
SECTION="multimedia"
VERSION=1.8.3
NAME="gst10-plugins-bad"

#REQ:gst10-plugins-base
#REC:libdvdread
#REC:libdvdnav
#REC:llvm
#REC:soundtouch
#OPT:bluez
#OPT:clutter
#OPT:curl
#OPT:faac
#OPT:faad2
#OPT:gnutls
#OPT:gtk-doc
#OPT:gtk2
#OPT:gtk3
#OPT:libass
#OPT:libexif
#OPT:libgcrypt
#OPT:libmpeg2
#OPT:x7driver
#OPT:libwebp
#OPT:mesa
#OPT:mpg123
#OPT:neon
#OPT:nettle
#OPT:opencv
#OPT:openjpeg
#OPT:openjpeg2
#OPT:opus
#OPT:qt5
#OPT:sdl
#OPT:valgrind
#OPT:wayland
#OPT:x265
#OPT:x7lib


cd $SOURCE_DIR

URL=http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.8.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins/gst-plugins-bad-1.8.3.tar.xz || wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.8.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins/gst-plugins-bad-1.8.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins/gst-plugins-bad-1.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins/gst-plugins-bad-1.8.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins/gst-plugins-bad-1.8.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --disable-wayland \
            --with-package-name="GStreamer Bad Plugins 1.8.3 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
