#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:wicd:1.7.4

#REQ:python2
#REQ:python-modules#dbus-python
#REQ:wireless_tools
#REQ:net-tools
#REC:python-modules#pygtk
#REC:wpa_supplicant
#REC:dhcpcd
#REC:dhcp
#OPT:pm-utils


cd $SOURCE_DIR

URL=https://launchpad.net/wicd/1.7/1.7.4/+download/wicd-1.7.4.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz || wget -nc https://launchpad.net/wicd/1.7/1.7.4/+download/wicd-1.7.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e "/detection failed/ a\                self.init=\'init\/default\/wicd\'" \
    -i.orig setup.py &&
rm po/*.po      &&
python setup.py configure --no-install-kde     \
                          --no-install-acpi    \
                          --no-install-pmutils \
                          --no-install-init    \
                          --docdir=/usr/share/doc/wicd-1.7.4



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
make install-wicd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "wicd=>`date`" | sudo tee -a $INSTALLED_LIST

