#!/bin/bash

set -e
set +h

RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'

function get_blk_id()
{
	BLKID=`blkid $1 | cut '-d"' -f2`
	echo $BLKID
}

clear
if [ ! -f /tmp/updated ]
then

echo -e "Benvenuto al  ${ORANGE}Arya${GREEN}Linux${NC} Builder."
echo -e "${NC}"
echo -e "${GREEN}AryaLinux sistema di compilazione"
echo -e "Copyright (C) 2015-16  Chandrakant Singh. Traduzione di Nicolò Altamura"

echo -e "Questo programma è un software libero: tu puoi ridisribuirlo e/o modificarlo"
echo -e "secondo i termini della GNU General Public License, pubblicata dalla"
echo -e " Free Software Foundation, secondo la terza versione"
echo ""
echo -e "Questo programma è distribuito nella speranza che sia utile,"
echo -e "ma SENZA ALCUNA GARANZIA, guarda la GNU per maggior informazioni"


echo -e "Tu dovresti aver ricevuto una copia della GNU General Public License"
echo -e "con questo programma. Se non è cosi, guarda <http://www.gnu.org/licenses/>."
echo -e "${NC}"

fi

echo "Informazioni di installazione:"
echo "Ci sono questi dispositivi nel tuo sistema:"
echo ""
echo "NAME    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT" && lsblk | grep disk | grep -v "boot" | sed -e 's/^/\/dev\//'
echo ""
read -p "Scrivi il nome del partizione es:  /dev/sda. Attenzione è /dev/sda e non  /dev/sda1 o /dev/sda2 etc.. : " DEV_NAME
echo "Questi sono le partizioni scelte nel disco:"
echo ""
echo "NAME    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT" && lsblk | grep part | grep -v "boot" | sed -r 's/^.{2}//' | sed -e 's/^/\/dev\//'
echo ""
read -p "Inserisci la partizione root per esempio /dev/sda1 or /dev/sda2 etc. Tutti i dati in questa partizione verranno persi. Fai il backup di ogni dato che è importante.  : " ROOT_PART
read -p "Inserisci la partizione di swap per esempio / Dev / sda1 o / dev / sda2 ecc. Questa partizione dovrebbe idealmente essere di dimensioni due volte la dimensione di RAM presente. Per esempio per la partizione di swap 2 GB di RAM dovrebbe essere di dimensioni 4 GB. Questa partizione verrà formattata . Backup di tutti i dati che sono importanti.: " SWAP_PART
read -p "Inserisci la partizione home esempio /dev/sda1 or /dev/sda2 etc. Qui è dove tutti i futuri dati saranno contenuti. Tutti i dati già esistenti verranno eliminati. Fai il backup di ogni dato che è importante : " HOME_PART

clear
echo "Informazioni riguardo il Computer e l'utente "
read -p "Inserisci il nome del computer : " HOST_NAME
read -p "Inserisci il nome completo (spazi consentiti) : " FULLNAME
read -p "Inserisci il nome utente per $FULLNAME(caratteri speciali non consentiti) : " USERNAME
read -p "Inserisci il dominio esempio: aryalinux.org : " DOMAIN_NAME

clear
echo "Nome OS, Versione e nome in codice:"
read -p "Inserisci il nome del'OS : " OS_NAME
read -p "Inserisci il nome in codice del'OS ad esempio Earth : " OS_CODENAME

clear
echo "Informazioni generali sulla compilazione:"
read -p "Inserisci la lingua locale esempio it_IT.utf8 : " LOCALE
read -p "Inserisci la dimensione della carta(A4/lettera) : " PAPER_SIZE
read -p "Vuoi usare il sistema con processori multipli? (y/n). Se scegli y (YES) il tuo sistema compilerà tutto in minor tempo ma sarà più stressato. Se non sei sicuro di avere processori multipli oppure stai usando una macchina virtuale scegli n (NO). " MULTICORE
read -p "Inserisci il tipo della tastiera:  " KEYBOARD

clear
TIMEZONE=`tzselect`

cat > build-properties << EOF
DEV_NAME="$DEV_NAME"
ROOT_PART="$ROOT_PART"
SWAP_PART="$SWAP_PART"
HOME_PART="$HOME_PART"
OS_NAME="$OS_NAME"
OS_CODENAME="$OS_CODENAME"
OS_VERSION="2016.08"
LOCALE="$LOCALE"
PAPER_SIZE="$PAPER_SIZE"
HOST_NAME="$HOST_NAME"
TIMEZONE="$TIMEZONE"
DOMAIN_NAME="$DOMAIN_NAME"
MULTICORE="$MULTICORE"
FULLNAME="$FULLNAME"
USERNAME="$USERNAME"
KEYBOARD="$KEYBOARD"
EOF

echo "Queste sono le proprietà che userò per la compilazione:"
echo ""
cat build-properties
echo ""
echo "Se tutto è okay, premi enter io incomincerò la compilazione. Altrimenti premi CTRL + C per annullare l'operazione. "
read RESPONSE

# Exit if root partition not specified.
if [ "x$ROOT_PART" == "x" ]
then
exit
fi

export LFS=/mnt/lfs

# Unmount the partitions if mounted and then format. Else would fail.
set +e
if [ "x$SWAP_PART" != "x" ]
then
swapoff $SWAP_PART
fi
umount $HOME_PART
# If root partition mounted somewhere other than $LFS then this would be taken care of...
umount $ROOT_PART
# Anything mounted on $LFS would be taken care of...
umount $LFS/dev/pts
umount $LFS/dev/shm
umount $LFS/dev
umount $LFS/sys
umount $LFS/proc
umount $LFS/run
umount $LFS/home
umount $LFS/boot/efi
umount $LFS
set -e

mkfs -v -t ext4 $ROOT_PART

mkdir -pv $LFS

mount -v -t ext4 $ROOT_PART $LFS

if [ "x$HOME_PART" != "x" ]
then
	mkdir -pv $LFS/home
fi

if [ "x$SWAP_PART" != "x" ]
then
	mkswap $SWAP_PART && /sbin/swapon -v $SWAP_PART || echo "Non posso creare lo swap #SWAP_PART perchè è già montato"
fi

ROOT_PART_BY_UUID=$(get_blk_id $ROOT_PART)

if [ "x$HOME_PART" != "x" ]
then
	mkfs -v -t ext4 $HOME_PART
	mount -v -t ext4 $HOME_PART $LFS/home
	HOME_PART_BY_UUID=$(get_blk_id $HOME_PART)
cat >> build-properties << EOF
HOME_PART_BY_UUID="$HOME_PART_BY_UUID"
EOF

fi

if [ "x$SWAP_PART" != "x" ]
then
	SWAP_PART_BY_UUID=$(get_blk_id $SWAP_PART)
cat >> build-properties << EOF
SWAP_PART_BY_UUID="$SWAP_PART_BY_UUID"
EOF

fi

cat >> build-properties << EOF
ROOT_PART_BY_UUID="$ROOT_PART_BY_UUID"
EOF

. ./build-properties

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
if [ -d ../../sources ]
then
	cp ../../sources/* $LFS/sources/
fi

rm -rf /sources
ln -svf $LFS/sources /
chmod -R a+rw /sources

rm -rf /tools
mkdir -v $LFS/tools
ln -sv $LFS/tools /

if grep "lfs" /etc/passwd &> /dev/null
then
	userdel -r lfs &> /dev/null
fi

rm /etc/profile.d/newuser.sh
rm -r /etc/skel/.config

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

chmod a+x *.sh
chmod a+x resume
chmod a+x toolchain/*.sh
chmod a+x final-system/*.sh

cp -r * /home/lfs/
cp -r * /sources
chown -R lfs:lfs /home/lfs/*

chmod a+x /home/lfs/*.sh

clear
echo "Inserisci lfs. Esegui 2.sh per continuare. Per eseguirlo, scrivere il seguente comando:"
echo "./2.sh"

cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

su - lfs

chown -R root:root $LFS/tools


mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

cp -v resume /tools/bin/resume
chmod a+x /tools/bin/resume

clear
echo "Would chroot into the toolchain."
echo "Per continuare scrivi il comando seguente:"
echo "resume"

chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h

rm -rf /tmp/*

clear
echo "Ancora una volta per compilare il kernel e installare il bootloader"
echo "Avvia 4.sh scrivendo il seguente comando:"
echo "cd /sources"
echo "./4.sh"

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login

echo "Cleaning up..."

rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libz.a

( sleep 5 && ./umountal.sh ) || ( echo "Impossibile montare la partizione di root Qualcosa è andato storto. Provare ./umountal.sh più tardi." && exit )

echo "Il sistema di base è stato costruito senza errori! Adesso dovresti riavviare il sistema e rifare il login. Per costruire il resto riaprire la console. Nel caso in cui qualcosa andasse storto oppure hai delle domande, puoi visitare la documentazione su aryalinux.org o su LinuxQuestion ."
echo "Se stai decidendo di creare una iso live, esegui il seguente comando (cambia en con la tua lingua):"
echo ""
echo "cd en"
echo "./strip-debug.sh"
echo ""
echo "Questo ridurrà la dimensione dell'iso che verrà creata. Questo programma userà i 'simboli di debug' dalle librerie e dagli esegubili  che sono stati costruiti. Rebuilding grub needs to be done because otherwise while booting grub would complain that symbols are not found."
echo "Ciao!"
