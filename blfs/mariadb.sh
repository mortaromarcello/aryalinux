#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mariadb:10.1.12

#REQ:cmake
#REQ:openssl
#REC:libevent
#OPT:boost
#OPT:libxml2
#OPT:linux-pam
#OPT:mitkrb
#OPT:pcre
#OPT:ruby
#OPT:unixodbc
#OPT:valgrind


cd $SOURCE_DIR

URL=https://downloads.mariadb.org/interstitial/mariadb-10.1.12/source/mariadb-10.1.12.tar.gz

wget -nc ftp://mirrors.fe.up.pt/pub/mariadb/mariadb-10.1.12/source/mariadb-10.1.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mariadb/mariadb-10.1.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mariadb/mariadb-10.1.12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mariadb/mariadb-10.1.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mariadb/mariadb-10.1.12.tar.gz || wget -nc https://downloads.mariadb.org/interstitial/mariadb-10.1.12/source/mariadb-10.1.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mariadb/mariadb-10.1.12.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 40 mysql &&
useradd -c "MySQL Server" -d /srv/mysql -g mysql -s /bin/false -u 40 mysql

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i "s@data/test@\${INSTALL_MYSQLTESTDIR}@g" sql/CMakeLists.txt &&
mkdir build &&
cd build    &&
cmake -DCMAKE_BUILD_TYPE=Release                       \
      -DCMAKE_INSTALL_PREFIX=/usr                      \
      -DINSTALL_DOCDIR=share/doc/mariadb-10.1.12       \
      -DINSTALL_DOCREADMEDIR=share/doc/mariadb-10.1.12 \
      -DINSTALL_MANDIR=share/man                       \
      -DINSTALL_MYSQLSHAREDIR=share/mysql              \
      -DINSTALL_MYSQLTESTDIR=share/mysql/test          \
      -DINSTALL_PLUGINDIR=lib/mysql/plugin             \
      -DINSTALL_SBINDIR=sbin                           \
      -DINSTALL_SCRIPTDIR=bin                          \
      -DINSTALL_SQLBENCHDIR=share/mysql/bench          \
      -DINSTALL_SUPPORTFILESDIR=share/mysql            \
      -DMYSQL_DATADIR=/srv/mysql                       \
      -DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock        \
      -DWITH_EXTRA_CHARSETS=complex                    \
      -DWITH_EMBEDDED_SERVER=ON                        \
      -DTOKUDB_OK=0                                    \
      .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm 755 /etc/mysql &&
cat > /etc/mysql/my.cnf << "EOF"
# Begin /etc/mysql/my.cnf
# The following options will be passed to all MySQL clients
[client]
#password = your_password
port = 3306
socket = /run/mysqld/mysqld.sock
# The MySQL server
[mysqld]
port = 3306
socket = /run/mysqld/mysqld.sock
datadir = /srv/mysql
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
sort_buffer_size = 512K
net_buffer_length = 16K
myisam_sort_buffer_size = 8M
# Don't listen on a TCP/IP port at all.
skip-networking
# required unique id between 1 and 2^32 - 1
server-id = 1
# Uncomment the following if you are using BDB tables
#bdb_cache_size = 4M
#bdb_max_lock = 10000
# InnoDB tables are now used by default
innodb_data_home_dir = /srv/mysql
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = /srv/mysql
# You can set .._buffer_pool_size up to 50 - 80 %
# of RAM but beware of setting memory usage too high
innodb_buffer_pool_size = 16M
innodb_additional_mem_pool_size = 2M
# Set .._log_file_size to 25 % of buffer pool size
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 50
[mysqldump]
quick
max_allowed_packet = 16M
[mysql]
no-auto-rehash
# Remove the next comment character if you are not familiar with SQL
#safe-updates
[isamchk]
key_buffer = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M
[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M
[mysqlhotcopy]
interactive-timeout
# End /etc/mysql/my.cnf
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mysql_install_db --basedir=/usr --datadir=/srv/mysql --user=mysql &&
chown -R mysql:mysql /srv/mysql

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -o mysql -g mysql -d /run/mysqld &&
mysqld_safe --user=mysql 2>&1 >/dev/null &

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sleep 5
clear



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mysqladmin -u root password

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mysqladmin -p shutdown

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.04/blfs-systemd-units-20150310.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20150310
make install-mysqld

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20150310
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mariadb=>`date`" | sudo tee -a $INSTALLED_LIST

