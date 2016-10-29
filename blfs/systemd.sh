#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak While systemd was installed whenbr3ak building LFS, there are many features provided by the package thatbr3ak were not included in the initial installation because Linux-PAM was not yet installed. Thebr3ak systemd package needs to bebr3ak rebuilt to provide a working <span class="command"><strong>systemd-logind</strong> service, whichbr3ak provides many additional features for dependent packages.br3ak"
SECTION="general"
VERSION=231
NAME="systemd"

#REQ:linux-pam
#REC:polkit
#OPT:cacerts
#OPT:curl
#OPT:elfutils
#OPT:gnutls
#OPT:iptables
#OPT:libgcrypt
#OPT:libidn
#OPT:libxkbcommon
#OPT:python2
#OPT:python3
#OPT:qemu
#OPT:valgrind
#OPT:zsh
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt


wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/systemd/systemd-231.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/systemd/systemd-231.tar.xz || wget -nc http://anduin.linuxfromscratch.org/sources/other/systemd/systemd-231.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/systemd/systemd-231.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/systemd/systemd-231.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/systemd/systemd-231.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/systemd/systemd-231-security_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/systemd-231-security_fix-1.patch


URL=http://anduin.linuxfromscratch.org/sources/other/systemd/systemd-231.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../systemd-231-security_fix-1.patch


sed -e 's:test/udev-test.pl ::g'  \
    -e 's:test-copy$(EXEEXT) ::g' \
    -i Makefile.in


cc_cv_CFLAGS__flto=no               \
XSLTPROC="/usr/bin/xsltproc"         \
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --with-rootprefix=       \
            --with-rootlibdir=/lib   \
            --enable-split-usr       \
            --disable-firstboot      \
            --disable-ldconfig       \
            --disable-sysusers       \
            --without-python         \
            --with-default-dnssec=no \
            --docdir=/usr/share/doc/systemd-231 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl start rescue.target

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -rfv /usr/lib/rpm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition
 
session required pam_loginuid.so
session optional pam_systemd.so
# End Systemd addition
EOF
cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user
account required pam_access.so
account include system-account
session required pam_env.so
session required pam_limits.so
session include system-session
auth required pam_deny.so
password required pam_deny.so
# End /etc/pam.d/systemd-user
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl daemon-reload
systemctl start multi-user.target

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
