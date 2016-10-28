#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak This section will describe how to set up, administer and secure abr3ak Subversion server.br3ak
#SECTION:general





NAME="svnserver"



URL=
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 56 svn &&
useradd -c "SVN Owner" -d /home/svn -m -g svn -s /bin/false -u 56 svn
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 57 svntest &&
usermod -G svntest -a svn
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv /usr/bin/svn /usr/bin/svn.orig &&
mv /usr/bin/svnserve /usr/bin/svnserve.orig &&
cat >> /usr/bin/svn << "EOF"
#!/bin/sh
umask 002
/usr/bin/svn.orig "$@"
EOF
cat >> /usr/bin/svnserve << "EOF"
#!/bin/sh
umask 002
/usr/bin/svnserve.orig "$@"
EOF
chmod 0755 /usr/bin/svn{,serve}
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 0755 -d /srv/svn &&
install -v -m 0755 -o svn -g svn -d /srv/svn/repositories &&
svnadmin create /srv/svn/repositories/svntest
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
svn import -m "Initial import." \
    <em class="replaceable"><code></path/to/source/tree></em>      \
    file:///srv/svn/repositories/svntest
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chown -R svn:svntest /srv/svn/repositories/svntest    &&
chmod -R g+w         /srv/svn/repositories/svntest    &&
chmod g+s            /srv/svn/repositories/svntest/db &&
usermod -G svn,svntest -a <em class="replaceable"><code><username></em>
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


svnlook tree /srv/svn/repositories/svntest/


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp /srv/svn/repositories/svntest/conf/svnserve.conf \
   /srv/svn/repositories/svntest/conf/svnserve.conf.default &&

cat > /srv/svn/repositories/svntest/conf/svnserve.conf << "EOF"
[general]
anon-access = read
auth-access = write
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
make install-svnserve
cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -p /etc/systemd/system/svnserve.service.d 
echo "UMask=0002" > /etc/systemd/system/svnserve.service.d/99-user.conf
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
