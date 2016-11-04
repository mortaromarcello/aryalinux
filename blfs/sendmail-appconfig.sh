#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 26 smmsp                               &&
useradd -c "Sendmail Daemon" -g smmsp -d /dev/null \
        -s /bin/false -u 26 smmsp                  &&
chmod -v 1777 /var/mail                            &&
install -v -m700 -d /var/spool/mqueue

}


postinstall()
{
echo "#"
}


$1
