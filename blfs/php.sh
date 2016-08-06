#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:php:7.0.3

#REC:apache
#REC:libxml2
#REC:aspell
#REC:enchant
#REC:libxslt
#REC:pcre
#REC:pth
#REC:freetype2
#REC:libexif
#REC:libjpeg
#REC:libpng
#REC:libtiff
#REC:curl
#REC:tidy-html5
#REC:db
#REC:openldap
#REC:postgresql
#REC:sqlite
#REC:unixodbc
#REC:openssl
#REC:cyrus-sasl
#REC:xorg-server
#REC:t1lib
#REC:gd
#REC:net-snmp
#OPT:aspell
#OPT:enchant
#OPT:libxslt
#OPT:pcre
#OPT:pth
#OPT:freetype2
#OPT:libexif
#OPT:libjpeg
#OPT:libpng
#OPT:libtiff
#OPT:curl
#OPT:tidy
#OPT:db
#OPT:mariadb
#OPT:openldap
#OPT:postgresql
#OPT:sqlite
#OPT:unixodbc
#OPT:openssl
#OPT:cyrus-sasl
#OPT:mitkrb
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://www.php.net/distributions/php-7.0.3.tar.xz

wget -nc http://www.php.net/distributions/php-7.0.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -i 's/buffio.h/tidy&/' ext/tidy/*.c


sed -i "s|lsystemd-daemon|lsystemd|g" configure &&
./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --with-apxs2                     \
            --with-config-file-path=/etc     \
            --disable-ipv6                   \
            --with-openssl                   \
            --with-kerberos                  \
            --with-pcre-regex=/usr           \
            --with-zlib                      \
            --enable-bcmath                  \
            --with-bz2                       \
            --enable-calendar                \
            --with-curl                      \
            --enable-dba=shared              \
            --with-gdbm                      \
            --enable-exif                    \
            --enable-ftp                     \
            --with-openssl-dir=/usr          \
            --with-gd=/usr                   \
            --with-jpeg-dir=/usr             \
            --with-png-dir=/usr              \
            --with-zlib-dir=/usr             \
            --with-xpm-dir=/usr/X11R6/lib    \
            --with-freetype-dir=/usr         \
            --with-t1lib                     \
            --with-gettext                   \
            --with-gmp                       \
            --with-ldap                      \
            --with-ldap-sasl                 \
            --enable-mbstring                \
            --with-mysql                     \
            --with-mysqli=mysqlnd            \
            --with-mysql-sock=/var/mysqld/mysqld.sock \
            --with-unixODBC=/usr             \
            --with-pdo-mysql                 \
            --with-pdo-odbc=unixODBC,/usr    \
            --with-pdo-pgsql                 \
            --without-pdo-sqlite             \
            --with-pgsql                     \
            --with-pspell                    \
            --with-readline                  \
            --with-snmp                      \
            --enable-sockets                 \
            --with-tidy                      \
            --with-xsl                       \
            --enable-fpm                     \
            --with-fpm-user=apache           \
            --with-fpm-group=apache          \
            --with-fpm-systemd               \
            --with-iconv                     &&
make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                         &&
install -v -m644 php.ini-production /etc/php.ini     &&
mv -v /etc/php-fpm.conf{.default,}                   &&
install -v -m755 -d /usr/share/doc/php-7.0.3 &&
install -v -m644    CODING_STANDARDS EXTENSIONS INSTALL NEWS README* UPGRADING* php.gif \
                    /usr/share/doc/php-7.0.3 &&
ln -v -sfn          /usr/lib/php/doc/Archive_Tar/docs/Archive_Tar.txt \
                    /usr/share/doc/php-7.0.3 &&
ln -v -sfn          /usr/lib/php/doc/Structures_Graph/docs \
                    /usr/share/doc/php-7.0.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v /etc/php-fpm.d/www.conf.default /etc/php-fpm.d/www.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i 's@php/includes"@&\ninclude_path = ".:/usr/lib/php"@' \
    /etc/php.ini

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i -e '/proxy_module/s/^#//'      \
       -e '/proxy_fcgi_module/s/^#//' \
       /etc/httpd/httpd.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo \
'ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/srv/www/$1' >> \
/etc/httpd/httpd.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.08/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-php-fpm

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20150310
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "php=>`date`" | sudo tee -a $INSTALLED_LIST
