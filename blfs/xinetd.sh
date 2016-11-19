#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak xinetd is the eXtended InterNETbr3ak services daemon, a secure replacement for <span class=\"command\"><strong>inetd</strong>.br3ak"
SECTION="server"
VERSION=2.3.15
NAME="xinetd"



cd $SOURCE_DIR

URL=ftp://anduin.linuxfromscratch.org/BLFS/xinetd/xinetd-2.3.15.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xinetd/xinetd-2.3.15.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xinetd/xinetd-2.3.15.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xinetd/xinetd-2.3.15.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xinetd/xinetd-2.3.15.tar.gz || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/xinetd/xinetd-2.3.15.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xinetd/xinetd-2.3.15.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i -e "s/exec_server/child_process/" xinetd/builtins.c       &&
sed -i -e "/register unsigned count/s/register//" xinetd/itox.c  &&
./configure --prefix=/usr --mandir=/usr/share/man --with-loadavg &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/xinetd.conf << "EOF"
# Begin /etc/xinetd
# Configuration file for xinetd
defaults
{
 instances = 60
 log_type = SYSLOG daemon
 log_on_success = HOST PID USERID
 log_on_failure = HOST USERID
 cps = 25 30
}
# All service files are stored in the /etc/xinetd.d directory
includedir /etc/xinetd.d
# End /etc/xinetd
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /etc/xinetd.d &&
cat > /etc/xinetd.d/systat << "EOF" &&
# Begin /etc/xinetd.d/systat
service systat
{
 disable = yes
 socket_type = stream
 wait = no
 user = nobody
 server = /bin/ps
 server_args = -auwwx
 only_from = 128.138.209.0
 log_on_success = HOST
}
# End /etc/xinetd.d/systat
EOF
cat > /etc/xinetd.d/echo << "EOF" &&
# Begin /etc/xinetd.d/echo
service echo
{
 disable = yes
 type = INTERNAL
 id = echo-stream
 socket_type = stream
 protocol = tcp
 user = root
 wait = no
}
service echo
{
 disable = yes
 type = INTERNAL
 id = echo-dgram
 socket_type = dgram
 protocol = udp
 user = root
 wait = yes
}
# End /etc/xinetd.d/echo
EOF
cat > /etc/xinetd.d/chargen << "EOF" &&
# Begin /etc/xinetd.d/chargen
service chargen
{
 disable = yes
 type = INTERNAL
 id = chargen-stream
 socket_type = stream
 protocol = tcp
 user = root
 wait = no
}
service chargen
{
 disable = yes
 type = INTERNAL
 id = chargen-dgram
 socket_type = dgram
 protocol = udp
 user = root
 wait = yes
}
# End /etc/xinetd.d/chargen
EOF
cat > /etc/xinetd.d/daytime << "EOF" &&
# Begin /etc/xinetd.d/daytime
service daytime
{
 disable = yes
 type = INTERNAL
 id = daytime-stream
 socket_type = stream
 protocol = tcp
 user = root
 wait = no
}
service daytime
{
 disable = yes
 type = INTERNAL
 id = daytime-dgram
 socket_type = dgram
 protocol = udp
 user = root
 wait = yes
}
# End /etc/xinetd.d/daytime
EOF
cat > /etc/xinetd.d/time << "EOF"
# Begin /etc/xinetd.d/time
service time
{
 disable = yes
 type = INTERNAL
 id = time-stream
 socket_type = stream
 protocol = tcp
 user = root
 wait = no
}
service time
{
 disable = yes
 type = INTERNAL
 id = time-dgram
 socket_type = dgram
 protocol = udp
 user = root
 wait = yes
}
# End /etc/xinetd.d/time
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-xinetd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl start xinetd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
