#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep ldap /etc/group &> /dev/null; then

groupadd -g 83 ldap &&
useradd  -c "OpenLDAP Daemon Owner" \
         -d /var/lib/openldap -u 83 \
         -g ldap -s /bin/false ldap
fi

}


preinstall()
{
echo "#"
}


$1
