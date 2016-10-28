#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Polkit is a toolkit for definingbr3ak and handling authorizations. It is used for allowing unprivilegedbr3ak processes to communicate with privileged processes.br3ak
#SECTION:postlfs

#REQ:glib2
#REQ:js
#REQ:systemd
#REC:linux-pam
#OPT:gobject-introspection
#OPT:docbook
#OPT:docbook-xsl
#OPT:gtk-doc
#OPT:libxslt


#VER:polkit:0.113


NAME="polkit"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/polkit/polkit-0.113.tar.gz || wget -nc http://www.freedesktop.org/software/polkit/releases/polkit-0.113.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit/polkit-0.113.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/polkit/polkit-0.113.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/polkit/polkit-0.113.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit/polkit-0.113.tar.gz


URL=http://www.freedesktop.org/software/polkit/releases/polkit-0.113.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -fg 27 polkitd &&
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i "s:/sys/fs/cgroup/systemd/:/sys:g" configure

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --localstatedir=/var             \
            --disable-static                 &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/polkit-1 << "EOF"
# Begin /etc/pam.d/polkit-1

auth include system-auth
account include system-account
password include system-password
session include system-session

# End /etc/pam.d/polkit-1
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
