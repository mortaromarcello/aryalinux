#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep rsyncd /etc/group &> /dev/null; then

groupadd -g 48 rsyncd &&
useradd -c "rsyncd Daemon" -d /home/rsync -g rsyncd \
    -s /bin/false -u 48 rsyncd
fi

}


preinstall()
{
echo "#"
}


$1
