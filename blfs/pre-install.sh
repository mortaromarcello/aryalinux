#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

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

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/lxqt.sh << "EOF"
# Begin LXQt profile
export LXQT_PREFIX=/opt/lxqt
pathappend /opt/lxqt/bin PATH
pathappend /opt/lxqt/share/man/ MANPATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH
# End LXQt profile
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
install -v -dm755                $LXQT_PREFIX/share/icons &&
ln -sfv /usr/share/icons/hicolor $LXQT_PREFIX/share/icons

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv /opt/lxqt{,-0.10.0}
ln -sfv lxqt-0.10.0 /opt/lxqt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "pre-install=>`date`" | sudo tee -a $INSTALLED_LIST

