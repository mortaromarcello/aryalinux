#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak PHP is the PHP Hypertextbr3ak Preprocessor. Primarily used in dynamic web sites, it allows forbr3ak programming code to be directly embedded into the HTML markup. Itbr3ak is also useful as a general purpose scripting language.br3ak
#SECTION:general

#REC:apache
#REC:libxml2
#OPT:aspell
#OPT:enchant
#OPT:libxslt
#OPT:mail
#OPT:pcre
#OPT:pth
#OPT:freetype2
#OPT:libexif
#OPT:libjpeg
#OPT:libpng
#OPT:libtiff
#OPT:installing
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


#VER:php:7.0.12


NAME="php"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/php/php-7.0.12.tar.xz || wget -nc http://www.php.net/distributions/php-7.0.12.tar.xz


URL=http://www.php.net/distributions/php-7.0.12.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i 's/buffio.h/tidy&/' ext/tidy/tidy.c

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
install -v -m644 ../php_manual_en.html.gz \
    /usr/share/doc/php-7.0.12 &&
gunzip -v /usr/share/doc/php-7.0.12/php_manual_en.html.gz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xvf ../php_manual_en.tar.gz \
    -C /usr/share/doc/php-7.0.12 --no-same-owner
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




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
