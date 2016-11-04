#!/bin/bash
set -e
set +h

function postinstall()
{

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
cat >> /etc/profile.d/extrapaths.sh << EOF

# Begin texlive addition
pathappend /opt/texlive/2016/texmf-dist/doc/man MANPATH
pathappend /opt/texlive/2016/texmf-dist/doc/info INFOPATH
pathappend /opt/texlive/2016/bin/$TEXARCH
# End texlive addition

EOF
unset TEXARCH

}


preinstall()
{
echo "#"
}


$1
