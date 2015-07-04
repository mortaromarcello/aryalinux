#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cyrus-sasl
#DEP:db
#DEP:openssl


cd $SOURCE_DIR

wget -nc ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.40.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/openldap-2.4.40-blfs_paths-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/openldap-2.4.40-symbol_versions-1.patch


TARBALL=openldap-2.4.40.tgz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../openldap-2.4.40-blfs_paths-1.patch &&
patch -Np1 -i ../openldap-2.4.40-symbol_versions-1.patch &&
autoconf &&

sed -i '/6.0.20/ a\\t__db_version_compat' configure &&

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dynamic  \
            --disable-debug   \
            --disable-slapd &&
make depend &&
make

cat > 1434987998788.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
/usr/sbin/groupadd -g 83 ldap &&
/usr/sbin/useradd -c "OpenLDAP Daemon Owner" -d /var/lib/openldap -u 83 \
        -g ldap -s /bin/false ldap
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "openldap=>`date`" | sudo tee -a $INSTALLED_LIST