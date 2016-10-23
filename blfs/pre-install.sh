#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:lxqt

whoami > /tmp/currentuser





NAME="pre-install"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export LXQT_PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/lxqt.sh << "EOF"
# Begin LXQt profile
export LXQT_PREFIX=/usr
# End LXQt profile
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /opt/lxqt/{bin,lib,share/man}
cat > /etc/profile.d/lxqt.sh << "EOF"
# Begin LXQt profile
export LXQT_PREFIX=/opt/lxqt
pathappend /opt/lxqt/bin PATH
pathappend /opt/lxqt/share/man/ MANPATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/plugins QT_PLUGIN_PATH
# End LXQt profile
EOF
cat >> /etc/profile.d/qt5.sh << "EOF"

# Begin Qt5 changes for LXQt
pathappend $QT5DIR/plugins QT_PLUGIN_PATH
# End Qt5 changes for LXQt
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << "EOF"

# Begin LXQt addition
/opt/lxqt/lib
# End LXQt addition

EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


source /etc/profile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
source /etc/profile                                       &&
ln -sfv /usr/share/dbus-1        $LXQT_PREFIX/share       &&
install -v -dm755                $LXQT_PREFIX/share/icons &&
ln -sfv /usr/share/icons/hicolor $LXQT_PREFIX/share/icons

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv /opt/lxqt{,-0.11.0}
ln -sfv lxqt-0.11.0 /opt/lxqt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


ls -Fd qt* | grep / | sed 's/^/-skip /;s/qt//;s@/@@' > tempconf
sed -i '/base/d;/tools/d;/x11extras/d;/svg/d' tempconf
# if you plan to build SDDM, add:
sed -i '/declarative/d'
./configure <book flags> $(cat tempconf)




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
