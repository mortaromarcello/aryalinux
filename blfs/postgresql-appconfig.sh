#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep postgres /etc/group &> /dev/null; then

install -v -dm700 /srv/pgsql/data &&
install -v -dm755 /run/postgresql &&
groupadd -g 41 postgres &&
useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
        -u 41 postgres &&
chown -Rv postgres:postgres /srv/pgsql /run/postgresql

fi

}


preinstall()
{
echo "#"
}


$1
