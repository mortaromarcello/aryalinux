#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 31 exim &&
useradd -d /dev/null -c "Exim Daemon" -g exim -s /bin/false -u 31 exim

}

funcrtion postinstall()
{

if ! grep -E "^postmaster:root" /etc/aliases &>/dev/null; then

cat >> /etc/aliases << "EOF"
postmaster: root
MAILER-DAEMON: root
EOF

fi

exim -v -bi &&
/usr/sbin/exim -bd -q15m

}




$1
