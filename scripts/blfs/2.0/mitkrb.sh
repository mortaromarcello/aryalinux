#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://web.mit.edu/kerberos/www/dist/krb5/1.13/krb5-1.13.1-signed.tar


TARBALL=krb5-1.13.1-signed.tar
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

gpg2 --verify krb5-1.13.1.tar.gz.asc krb5-1.13.1.tar.gz

gpg2 --pgp2 --keyserver pgp.mit.edu --recv-keys 0x749D7889

cd src &&
sed -e "s@python2.5/Python.h@& python2.7/Python.h@g" \
    -e "s@-lpython2.5]@&,\n  AC_CHECK_LIB(python2.7,main,[PYTHON_LIB=-lpython2.7])@g" \
    -i configure.in &&
autoconf &&
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --with-system-et         \
            --with-system-ss         \
            --without-system-verto   \
            --enable-dns-for-realm   &&
make

cat > 1434987998748.sh << "ENDOFFILE"
make install &&

for LIBRARY in gssapi_krb5 gssrpc k5crypto kadm5clnt kadm5srv \
               kdb5 kdb_ldap krad krb5 krb5support verto ; do
    [ -e  /usr/lib/lib$LIBRARY.so ] && chmod -v 755 /usr/lib/lib$LIBRARY.so
done &&
unset LIBRARY &&

mv -v /usr/lib/libkrb5.so.*        /lib &&
mv -v /usr/lib/libk5crypto.so.*    /lib &&
mv -v /usr/lib/libkrb5support.so.* /lib &&

ln -sfv ../../lib/$(readlink /usr/lib/libkrb5.so)        /usr/lib/libkrb5.so        &&
ln -sfv ../../lib/$(readlink /usr/lib/libk5crypto.so)    /usr/lib/libk5crypto.so    &&
ln -sfv ../../lib/$(readlink /usr/lib/libkrb5support.so) /usr/lib/libkrb5support.so &&

mv -v /usr/bin/ksu /bin &&
chmod -v 755 /bin/ksu   &&

install -v -dm755 /usr/share/doc/krb5-1.13.1 &&
cp -rfv ../doc/*  /usr/share/doc/krb5-1.13.1
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
cat > /etc/krb5.conf << "EOF"
# Begin /etc/krb5.conf

[libdefaults]
 default_realm = <em class="replaceable"><code><LFS.ORG></em>
 encrypt = true

[realms]
 <em class="replaceable"><code><LFS.ORG></em> = {
 kdc = <em class="replaceable"><code><belgarath.lfs.org></em>
 admin_server = <em class="replaceable"><code><belgarath.lfs.org></em>
 dict_file = /usr/share/dict/words
 }

[domain_realm]
 .<em class="replaceable"><code><lfs.org></em> = <em class="replaceable"><code><LFS.ORG></em>

[logging]
 kdc = SYSLOG[:INFO[:AUTH]]
 admin_server = SYSLOG[INFO[:AUTH]]
 default = SYSLOG[[:SYS]]

# End /etc/krb5.conf
EOF
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
kdb5_util create -r <em class="replaceable"><code><LFS.ORG></em> -s
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
kadmin.local
<code class="prompt">kadmin.local: add_policy dict-only
<code class="prompt">kadmin.local: addprinc -policy dict-only <em class="replaceable"><code><loginname></em>
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
<code class="prompt">kadmin.local: addprinc -randkey host/<em class="replaceable"><code><belgarath.lfs.org></em>
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
<code class="prompt">kadmin.local: ktadd host/<em class="replaceable"><code><belgarath.lfs.org></em>
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
/usr/sbin/krb5kdc
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

kinit <em class="replaceable"><code><loginname></em>

klist

ktutil
<code class="prompt">ktutil: rkt /etc/krb5.keytab
<code class="prompt">ktutil: l

cat > 1434987998748.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-krb5
cd ..
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mitkrb=>`date`" | sudo tee -a $INSTALLED_LIST