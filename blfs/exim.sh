#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Exim package contains a Mailbr3ak Transport Agent written by the University of Cambridge, releasedbr3ak under the GNU Public License.br3ak
#SECTION:server

#REQ:pcre
#OPT:db
#OPT:cyrus-sasl
#OPT:libidn
#OPT:linux-pam
#OPT:mariadb
#OPT:openldap
#OPT:openssl
#OPT:gnutls
#OPT:postgresql
#OPT:sqlite
#OPT:installing


#VER:exim:4.87


NAME="exim"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/exim/exim-4.87.tar.bz2 || wget -nc ftp://ftp.exim.org/pub/exim/exim4/exim-4.87.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/exim/exim-4.87.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/exim/exim-4.87.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/exim/exim-4.87.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/eximftp/exim/exim4/exim-4.87.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/exim/exim-4.87.tar.bz2


URL=http://mirrors-usa.go-parts.com/eximftp/exim/exim4/exim-4.87.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 31 exim &&
useradd -d /dev/null -c "Exim Daemon" -g exim -s /bin/false -u 31 exim
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -e 's,^BIN_DIR.*$,BIN_DIRECTORY=/usr/sbin,' \
    -e 's,^CONF.*$,CONFIGURE_FILE=/etc/exim.conf,' \
    -e 's,^EXIM_USER.*$,EXIM_USER=exim,' \
    -e 's,^EXIM_MONITOR,#EXIM_MONITOR,' src/EDITME > Local/Makefile &&
printf "USE_GDBM = yes\nDBMLIB = -lgdbm\n" >> Local/Makefile &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                      &&
install -v -m644 doc/exim.8 /usr/share/man/man8   &&
install -v -d -m755 /usr/share/doc/exim-4.87    &&
install -v -m644 doc/* /usr/share/doc/exim-4.87 &&
ln -sfv exim /usr/sbin/sendmail                   &&
install -v -d -m750 -o exim -g exim /var/spool/exim
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chmod -v a+wt /var/mail
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/aliases << "EOF"
postmaster: root
MAILER-DAEMON: root
EOF
exim -v -bi &&
/usr/sbin/exim -bd -q15m
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-exim
cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
