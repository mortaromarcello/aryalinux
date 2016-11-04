#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 83 ldap &&
useradd  -c "OpenLDAP Daemon Owner" \
         -d /var/lib/openldap -u 83 \
         -g ldap -s /bin/false ldap

}


postinstall()
{
echo "#"
}


$1
