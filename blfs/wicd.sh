#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Wicd is a network manager writtenbr3ak in Python. It simplifies network setup by automatically detectingbr3ak and connecting to wireless and wired networks. Wicd includesbr3ak support for WPA authentication and DHCP configuration. It providesbr3ak Curses- and GTK-based graphical frontends for user-friendlybr3ak control. An excellent KDE-based frontend is also availablebr3ak <a class="ulink" href="http://projects.kde.org/projects/extragear/network/wicd-kde">http://projects.kde.org/projects/extragear/network/wicd-kde</a>.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REQ:python2
#REQ:python-modules#dbus-python
#REQ:wireless_tools
#REQ:net-tools
#REC:python-modules#pygtk
#REC:wpa_supplicant
#REC:dhcpcd
#REC:dhcp
#OPT:pm-utils


#VER:wicd:1.7.4


NAME="wicd"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz || wget -nc https://launchpad.net/wicd/1.7/1.7.4/+download/wicd-1.7.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wicd/wicd-1.7.4.tar.gz


URL=https://launchpad.net/wicd/1.7/1.7.4/+download/wicd-1.7.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed "/detection failed/ a\ self.init=\'init\/default\/wicd\'" \
    -i.orig setup.py &&
rm po/*.po           &&
python setup.py configure --no-install-kde     \
                          --no-install-acpi    \
                          --no-install-pmutils \
                          --no-install-init    \
                          --no-install-gnome-shell-extensions \
                          --docdir=/usr/share/doc/wicd-1.7.4



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-wicd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
