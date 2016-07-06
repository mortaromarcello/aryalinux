#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gst-plugins-bad:1.6.3

#REQ:gst10-plugins-base
#REC:libdvdread
#REC:libdvdnav
#REC:llvm
#REC:soundtouch
#OPT:bluez
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
#OPT:libvdpau
#OPT:mesa
#OPT:mpg123
#OPT:neon
#OPT:openjpeg
#OPT:openjpeg2
#OPT:sdl
#OPT:valgrind
#OPT:x7lib
#OPT:wayland


cd $SOURCE_DIR

URL=http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.6.3.tar.xz

wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.6.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.6.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.6.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.6.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.6.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.6.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/openjpeg-2/ s/0/1/' \
    -i configure ext/openjpeg/gstopenjpeg.h &&
sed -e '/user_data (/ s/mstream/&, NULL/' \
    -i ext/openjpeg/gstopenjpeg{enc,dec}.c  &&


./configure --prefix=/usr \
            --with-package-name="GStreamer Bad Plugins 1.6.3 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gst10-plugins-bad=>`date`" | sudo tee -a $INSTALLED_LIST

