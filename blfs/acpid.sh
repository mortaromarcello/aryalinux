#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The acpid (Advanced Configurationbr3ak and Power Interface event daemon) is a completely flexible, totallybr3ak extensible daemon for delivering ACPI events. It listens on netlinkbr3ak interface and when an event occurs, executes programs to handle thebr3ak event. The programs it executes are configured through a set ofbr3ak configuration files, which can be dropped into place by packages orbr3ak by the user.br3ak"
SECTION="general"
VERSION=2.0.28
NAME="acpid"



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/acpid2/acpid-2.0.28.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://downloads.sourceforge.net/acpid2/acpid-2.0.28.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --docdir=/usr/share/doc/acpid-2.0.28 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /etc/acpi/events &&
cp -r samples /usr/share/doc/acpid-2.0.28

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/acpi/events/lid << "EOF"
event=button/lid
action=/etc/acpi/lid.sh
EOF
cat > /etc/acpi/lid.sh << "EOF"
#!/bin/sh
/bin/grep -q open /proc/acpi/button/lid/LID/state && exit 0
/usr/sbin/pm-suspend
EOF
chmod +x /etc/acpi/lid.sh

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20160902.tar.xz -O $SOURCE_DIR/blfs-bootscripts-20160902.tar.xz
tar xf $SOURCE_DIR/blfs-bootscripts-20160902.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-bootscripts-20160902
make install-acpid

cd $SOURCE_DIR
rm -rf blfs-bootscripts-20160902
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
