#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#REQ:cmake
#REQ:openssl
#REC:libevent
#OPT:boost
#OPT:libxml2
#OPT:linux-pam
#OPT:pcre
#OPT:ruby
#OPT:unixodbc
#OPT:valgrind

cd $SOURCE_DIR

sudo userdel -r mysql
sudo groupadd -g 40 mysql &&
sudo useradd -c "MySQL Server" -d /srv/mysql -g mysql -s /bin/false -u 40 mysql

URL=http://ftp.jaist.ac.jp/pub/mysql/Downloads/MySQL-5.6/mysql-5.6.27.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export MYSQL_PREFIX=/opt/mysql

mkdir -pv build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$MYSQL_PREFIX ..
make "-j`nproc`"
sudo make install

cd $MYSQL_PREFIX

sudo scripts/mysql_install_db --user=mysql

sudo chown -R root .
sudo chown -R mysql data

sudo mkdir -pv /run/mysqld
sudo chown -R mysql /run/mysqld

sudo install -v -dm 755 /etc/mysql &&
sudo tee /etc/mysql/my.cnf << "EOF"
# Begin /etc/mysql/my.cnf

# The following options will be passed to all MySQL clients
[client]
#password       = your_password
port            = 3306
socket          = /run/mysqld/mysqld.sock

# The MySQL server
[mysqld]
port            = 3306
socket          = /run/mysqld/mysqld.sock
datadir         = /opt/mysql/data
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
sort_buffer_size = 512K
net_buffer_length = 16K
myisam_sort_buffer_size = 8M

# Don't listen on a TCP/IP port at all.
# skip-networking

# required unique id between 1 and 2^32 - 1
server-id       = 1

# Uncomment the following if you are using BDB tables
#bdb_cache_size = 4M
#bdb_max_lock = 10000

# Uncomment the following if you are using InnoDB tables
#innodb_data_home_dir = /opt/mysql/data
#innodb_data_file_path = ibdata1:10M:autoextend
#innodb_log_group_home_dir = /opt/mysql
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

sudo bin/mysqld_safe --user=mysql &
sleep 5 &&
sudo bin/mysqladmin -u root password
sudo bin/mysqladmin -p shutdown

sudo tee /lib/systemd/system/mysqld.service <<"EOF"
[Unit]
Description=MySQL Server
After=network.target

[Service]
User=mysql
Group=mysql
ExecStart=/opt/mysql/bin/mysqld --pid-file=/run/mysqld/mysqld.pid
Restart=always
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable mysqld

sudo tee /etc/profile.d/mysql.sh <<"EOF"
export PATH=$PATH:/opt/mysql/bin
EOF

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "mysql=>`date`" | sudo tee -a $INSTALLED_LIST
