#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep "session optional pam_systemd.so" /etc/pam.d/system-session &> /dev/null
then

cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition
 
session required pam_loginuid.so
session optional pam_systemd.so
# End Systemd addition
EOF

fi

if [ ! -f /etc/pam.d/systemd-user ]; then

if ! grep "password required pam_deny.so" /etc/pam.d/systemd-user &> /dev/null
then

cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user
account required pam_access.so
account include system-account
session required pam_env.so
session required pam_limits.so
session include system-session
auth required pam_deny.so
password required pam_deny.so
# End /etc/pam.d/systemd-user
EOF

fi

fi

}


preinstall()
{
echo "#"
}


$1
