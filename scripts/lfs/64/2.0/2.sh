set -e
set +h

. inputs

mkdir -pv /{bin,boot,dev,{etc/,}opt,home,lib,mnt}
mkdir -pv /{proc,media/{floppy,cdrom},run/shm,sbin,srv,sys}
mkdir -pv /var/{lock,log,mail,spool}
mkdir -pv /var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 /root
install -dv -m 1777 {/var,}/tmp
ln -sv ../run /var/run
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}

ln -sv /tools/bin/{bash,cat,echo,grep,pwd,stty} /bin
ln -sv /tools/bin/file /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.so{.6,} /usr/lib
sed -e 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
ln -sv bash /bin/sh

mkdir -pv /usr/lib64
ln -sv /tools/lib/libstdc++.so{.6,} /usr/lib64

ln -sv /proc/self/mounts /etc/mtab

export BUILD64="-m64"

echo export BUILD64=\""${BUILD64}\"" >> ~/.bash_profile

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:/bin:/bin/false
daemon:x:2:6:/sbin:/bin/false
messagebus:x:27:27:D-Bus Message Daemon User:/dev/null:/bin/false
nobody:x:65534:65533:Unprivileged User:/dev/null:/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:5:
tape:x:4:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:27:
systemd-journal:x:28:
mail:x:30:
wheel:x:39:
nogroup:x:65533:
EOF

clear
echo "Done. Now execute 3.sh by entering the following below:"
echo "./3.sh"

exec /tools/bin/bash --login +h

