#!/bin/bash
set -e
set +h

groupadd -g 32 postfix &&
groupadd -g 33 postdrop &&
useradd -c "Postfix Daemon User" -d /var/spool/postfix -g postfix \
        -s /bin/false -u 32 postfix &&
chown -v postfix:postfix /var/mail

cat >> /etc/aliases << "EOF"
# Begin /etc/aliases
MAILER-DAEMON: postmaster
postmaster: root
root: <em class="replaceable"><code><LOGIN></em>
# End /etc/aliases
EOF

