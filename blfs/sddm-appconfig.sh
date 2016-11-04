#!/bin/bash
set -e
set +h

groupadd -g 64 sddm &&
useradd  -c "SDDM Daemon" \
         -d /var/lib/sddm \
         -u 64 -g sddm    \
         -s /bin/false sddm

echo 'setxkbmap <em class="replaceable"><code>"<your keyboard comma separated list>"</em>' >> \
     /usr/share/sddm/scripts/Xsetup

echo "source /etc/profile.d/dircolors.sh" >> /etc/bashrc

