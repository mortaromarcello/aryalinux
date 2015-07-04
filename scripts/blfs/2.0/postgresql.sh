#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.postgresql.org/pub/source/v9.4.1/postgresql-9.4.1.tar.bz2
wget -nc ftp://ftp.postgresql.org/pub/source/v9.4.1/postgresql-9.4.1.tar.bz2


TARBALL=postgresql-9.4.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/DEFAULT_PGSOCKET_DIR/s@/tmp@/run/postgresql@' src/include/pg_config_manual.h &&
./configure --prefix=/usr          \
            --enable-thread-safety \
            --docdir=/usr/share/doc/postgresql-9.4.1 &&
make

cat > 1434987998788.sh << "ENDOFFILE"
make install      &&
make install-docs
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
install -v -dm700 /srv/pgsql/data &&
install -v -dm755 /run/postgresql &&
groupadd -g 41 postgres &&
useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
        -u 41 postgres &&
chown -Rv postgres:postgres /srv/pgsql /run/postgresql &&
su - postgres -c '/usr/bin/initdb -D /srv/pgsql/data'
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
su - postgres -c '/usr/bin/postmaster -D /srv/pgsql/data > \
    /srv/pgsql/data/logfile 2>&1 &'
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
su - postgres -c '/usr/bin/createdb test' &&
echo "create table t1 ( name varchar(20), state_province varchar(20) );" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Billy', 'NewYork');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Evanidus', 'Quebec');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Jesse', 'Ontario');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "select * from t1;" | (su - postgres -c '/usr/bin/psql test')
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-postgresql
cd ..
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "postgresql=>`date`" | sudo tee -a $INSTALLED_LIST