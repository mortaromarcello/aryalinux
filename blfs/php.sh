#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak PHP is the PHP Hypertextbr3ak Preprocessor. Primarily used in dynamic web sites, it allows forbr3ak programming code to be directly embedded into the HTML markup. Itbr3ak is also useful as a general purpose scripting language.br3ak"
SECTION="general"
VERSION=7.0.12
NAME="php"

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
#OPT:tidy-html5
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

URL=http://www.php.net/distributions/php-7.0.12.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc http://www.php.net/distributions/php-7.0.12.tar.xz

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

sed -i 's/buffio.h/tidy&/' ext/tidy/tidy.c


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
            --with-mysql-sock=/var/run/mysql \
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
install -v -m755 -d /usr/share/doc/php-7.0.12 &&
install -v -m644    CODING_STANDARDS EXTENSIONS INSTALL NEWS README* UPGRADING* php.gif \
                    /usr/share/doc/php-7.0.12 &&
ln -v -sfn          /usr/lib/php/doc/Archive_Tar/docs/Archive_Tar.txt \
                    /usr/share/doc/php-7.0.12 &&
ln -v -sfn          /usr/lib/php/doc/Structures_Graph/docs \
                    /usr/share/doc/php-7.0.12

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
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-php-fpm

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
