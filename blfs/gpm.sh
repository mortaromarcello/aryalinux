#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GPM (General Purpose Mousebr3ak daemon) package contains a mouse server for the console andbr3ak <span class="command"><strong>xterm</strong>. It not onlybr3ak provides cut and paste support generally, but its library componentbr3ak is used by various software such as Links to provide mouse support to thebr3ak application. It is useful on desktops, especially if followingbr3ak (Beyond) Linux From Scratch instructions; it's often much easierbr3ak (and less error prone) to cut and paste between two console windowsbr3ak than to type everything by hand!br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:gpm:1.20.7


NAME="gpm"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc http://www.nico.schottelius.org/software/gpm/archives/gpm-1.20.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2


URL=http://www.nico.schottelius.org/software/gpm/archives/gpm-1.20.7.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh                                &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                          &&
install-info --dir-file=/usr/share/info/dir           \
             /usr/share/info/gpm.info                 &&
ln -sfv libgpm.so.2.1.0 /usr/lib/libgpm.so            &&
install -v -m644 conf/gpm-root.conf /etc              &&
install -v -m755 -d /usr/share/doc/gpm-1.20.7/support &&
install -v -m644    doc/support/*                     \
                    /usr/share/doc/gpm-1.20.7/support &&
install -v -m644    doc/{FAQ,HACK_GPM,README*}        \
                    /usr/share/doc/gpm-1.20.7

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-gpm

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /etc/systemd/system/gpm.service.d
echo "ExecStart=/usr/sbin/gpm <list of parameters>" > /etc/systemd/system/gpm.service.d/99-user.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
