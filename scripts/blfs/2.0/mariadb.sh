#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:openssl
#DEP:libevent


cd $SOURCE_DIR

wget -nc https://downloads.mariadb.org/interstitial/mariadb-10.0.16/source/mariadb-10.0.16.tar.gz
wget -nc ftp://mirrors.fe.up.pt/pub/mariadb/mariadb-10.0.16/source/mariadb-10.0.16.tar.gz


TARBALL=mariadb-10.0.16.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998787.sh << "ENDOFFILE"
groupadd -g 40 mysql &&
useradd -c "MySQL Server" -d /srv/mysql -g mysql -s /bin/false -u 40 mysql
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

sed -i "s@data/test@\${INSTALL_MYSQLTESTDIR}@g"        sql/CMakeLists.txt       &&
sed -i "s/srv_buf_size/srv_sort_buf_size/"      storage/innobase/row/row0log.cc &&

mkdir build &&
cd build    &&

cmake -DCMAKE_BUILD_TYPE=Release                       \
      -DCMAKE_INSTALL_PREFIX=/usr                      \
      -DINSTALL_DOCDIR=share/doc/mariadb-10.0.16       \
      -DINSTALL_DOCREADMEDIR=share/doc/mariadb-10.0.16 \
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
make

cat > 1434987998787.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
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

# Uncomment the following if you are using InnoDB tables
#innodb_data_home_dir = /srv/mysql
#innodb_data_file_path = ibdata1:10M:autoextend
#innodb_log_group_home_dir = /srv/mysql
# You can set .._buffer_pool_size up to 50 - 80 %
# of RAM but beware of setting memory usage too high
#innodb_buffer_pool_size = 16M
#innodb_additional_mem_pool_size = 2M
# Set .._log_file_size to 25 % of buffer pool size
#innodb_log_file_size = 5M
#innodb_log_buffer_size = 8M
#innodb_flush_log_at_trx_commit = 1
#innodb_lock_wait_timeout = 50

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
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
mysql_install_db --basedir=/usr --datadir=/srv/mysql --user=mysql &&
chown -R mysql:mysql /srv/mysql
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
install -v -m755 -o mysql -g mysql -d /run/mysqld &&
mysqld_safe --user=mysql 2>&1 >/dev/null &
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
mysqladmin -u root password
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
mysqladmin -p shutdown
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-mysqld
cd ..
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mariadb=>`date`" | sudo tee -a $INSTALLED_LIST