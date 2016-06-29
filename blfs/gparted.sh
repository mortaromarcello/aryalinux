#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gparted:0.26.0

#REQ:gtkmm2
#REQ:parted
#OPT:rarian


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/gparted/gparted-0.26.0.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gparted/gparted-0.26.0.tar.gz || wget -nc http://downloads.sourceforge.net/gparted/gparted-0.26.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gparted/gparted-0.26.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gparted/gparted-0.26.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gparted/gparted-0.26.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gparted/gparted-0.26.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-doc    \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v /usr/share/applications/gparted.desktop /usr/share/applications/gparted.desktop.back &&
sed -i 's/Exec=/Exec=sudo -A /'               /usr/share/applications/gparted.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v /usr/share/applications/gparted.desktop \
                                     /usr/share/applications/gparted.desktop.back &&
sed -i 's:/usr/sbin/gparted:/usr/sbin/gparted_polkit:' \
                                     /usr/share/applications/gparted.desktop      &&
cat > /usr/sbin/gparted_polkit << "EOF" &&
#!/bin/bash
pkexec /usr/sbin/gparted $@
EOF
chmod -v 0755 /usr/sbin/gparted_polkit

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /usr/share/polkit-1/actions/org.gnome.gparted.policy << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>
 <action id="org.freedesktop.policykit.pkexec.run-gparted">
 <description>Run GParted</description>
 <message>Authentication is required to run GParted</message>
 <defaults>
 <allow_any>no</allow_any>
 <allow_inactive>no</allow_inactive>
 <allow_active>auth_admin_keep</allow_active>
 </defaults>
 <annotate key="org.freedesktop.policykit.exec.path">/usr/sbin/gparted</annotate>
 <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
 </action>
</policyconfig>
EOF
chmod -v 0644 /usr/share/polkit-1/actions/org.gnome.gparted.policy

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gparted=>`date`" | sudo tee -a $INSTALLED_LIST

