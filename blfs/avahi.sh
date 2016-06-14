#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:avahi:0.6.31

#REQ:glib2
#REC:gobject-introspection
#REC:gtk2
#REC:gtk3
#REC:libdaemon
#REC:libglade
#OPT:python-modules#dbus-python
#OPT:python-modules#pygtk
#OPT:qt4


cd $SOURCE_DIR

URL=http://avahi.org/download/avahi-0.6.31.tar.gz

wget -nc http://avahi.org/download/avahi-0.6.31.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/avahi/avahi-0.6.31.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/avahi/avahi-0.6.31.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/avahi/avahi-0.6.31.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/avahi/avahi-0.6.31.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/avahi/avahi-0.6.31.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -fg 84 avahi &&
useradd -c "Avahi Daemon Owner" -d /var/run/avahi-daemon -u 84 \
        -g avahi -s /bin/false avahi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -fg 86 netdev

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i 's/\(CFLAGS=.*\)-Werror \(.*\)/\1\2/' configure &&
sed -e 's/-DG_DISABLE_DEPRECATED=1//' \
    -e '/-DGDK_DISABLE_DEPRECATED/d'  \
    -i avahi-ui/Makefile.in &&
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --disable-mono       \
            --disable-monodoc    \
            --disable-python     \
            --disable-qt3        \
            --disable-qt4        \
            --enable-core-docs   \
            --with-distro=none   \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable avahi-daemon

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable avahi-dnsconfd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "avahi=>`date`" | sudo tee -a $INSTALLED_LIST

