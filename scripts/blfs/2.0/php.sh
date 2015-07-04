#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apache
#DEP:libxml2


cd $SOURCE_DIR

wget -nc http://www.php.net/distributions/php-5.6.6.tar.xz
wget -nc ftp://ftp.isu.edu.tw/pub/Unix/Web/PHP/distributions/php-5.6.6.tar.xz


TARBALL=php-5.6.6.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s|lsystemd-daemon|lsystemd|g" configure &&

./configure --prefix=/usr                \
            --sysconfdir=/etc            \
            --localstatedir=/var         \
            --datadir=/usr/share/php     \
            --mandir=/usr/share/man      \
            --enable-fpm                 \
            --with-fpm-user=apache       \
            --with-fpm-group=apache      \
            --with-fpm-systemd           \
            --with-config-file-path=/etc \
            --with-zlib                  \
            --enable-bcmath              \
            --with-bz2                   \
            --enable-calendar            \
            --enable-dba=shared          \
            --with-gdbm                  \
            --with-gmp                   \
            --enable-ftp                 \
            --with-gettext               \
            --enable-mbstring            \
            --with-readline              &&
make

cat > 1434987998776.sh << "ENDOFFILE"
make install                                         &&
install -v -m644 php.ini-production /etc/php.ini     &&
mv -v /etc/php-fpm.conf{.default,}                   &&

install -v -dm755 /usr/share/doc/php-5.6.6 &&
install -v -m644  CODING_STANDARDS EXTENSIONS INSTALL NEWS README* UPGRADING* php.gif \
                  /usr/share/doc/php-5.6.6 &&
ln -sfv           /usr/lib/php/doc/Archive_Tar/docs/Archive_Tar.txt \
                  /usr/share/doc/php-5.6.6 &&
ln -sfv           /usr/lib/php/doc/Structures_Graph/docs \
                  /usr/share/doc/php-5.6.6
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
install -v -m644 ../php_manual_en.html.gz \
    /usr/share/doc/php-5.6.6 &&
gunzip -v /usr/share/doc/php-5.6.6/php_manual_en.html.gz
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
tar -xvf ../php_manual_en.tar.gz \
    -C /usr/share/doc/php-5.6.6 --no-same-owner
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
sed -i 's@php/includes"@&\ninclude_path = ".:/usr/lib/php"@' \
    /etc/php.ini
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
sed -e '/proxy_module/s/^#//'      \
    -e '/proxy_fcgi_module/s/^#//' \
    -i  /etc/httpd/httpd.conf
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
echo 'ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/srv/www/$1' >> \
     /etc/httpd/httpd.conf
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-php-fpm
cd ..
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "php=>`date`" | sudo tee -a $INSTALLED_LIST