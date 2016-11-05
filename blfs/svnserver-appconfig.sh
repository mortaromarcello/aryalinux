#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep svn /etc/group &> /dev/null; then
groupadd -g 56 svn &&
useradd -c "SVN Owner" -d /home/svn -m -g svn -s /bin/false -u 56 svn

groupadd -g 57 svntest &&
usermod -G svntest -a svn

mv /usr/bin/svn /usr/bin/svn.orig &&
mv /usr/bin/svnserve /usr/bin/svnserve.orig &&
cat >> /usr/bin/svn << "EOF"
#!/bin/sh
umask 002
/usr/bin/svn.orig ""
EOF
cat >> /usr/bin/svnserve << "EOF"
#!/bin/sh
umask 002
/usr/bin/svnserve.orig ""
EOF
chmod 0755 /usr/bin/svn{,serve}

chown -R svn:svntest /srv/svn/repositories/svntest    &&
chmod -R g+w         /srv/svn/repositories/svntest    &&
chmod g+s            /srv/svn/repositories/svntest/db &&
usermod -G svn,svntest -a cat `/tmp/currentuser`

}


function preinstall()
{
echo "#"
}

$1
