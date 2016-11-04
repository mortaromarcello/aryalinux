#!/bin/bash
set -e
set +h

function postinstall()
{

cat >> /etc/profile.d/extrapaths.sh << EOF

# Begin Apache-ant addition
pathappend /opt/ant/bin
export ANT_HOME=/opt/ant
# End Apache-ant addition

EOF

}


preinstall()
{
echo "#"
}


$1
