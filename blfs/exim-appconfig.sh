#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep exim /etc/group &> /dev/null; then

groupadd -g 31 exim &&
useradd -d /dev/null -c "Exim Daemon" -g exim -s /bin/false -u 31 exim
fi

if ! grep -E "^postmaster:root" /etc/aliases &>/dev/null; then

cat >> /etc/aliases << "EOF"
postmaster: root
MAILER-DAEMON: root
EOF

fi

exim -v -bi &&
/usr/sbin/exim -bd -q15m

}

function preinstall()
{
echo "#"
}


$1
