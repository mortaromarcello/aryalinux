#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

if ! grep "$1=>" /etc/alps/installed-list
then

pushd $SOURCE_DIR

sudo rm -rf upper
sudo rm -rf work

set +e
sudo umount /tmp/mountpoint &> /dev/null
sudo umount /tmp/mountpoint/dev/pts &> /dev/null
sudo umount /tmp/mountpoint/dev &> /dev/null
sudo umount /tmp/mountpoint/sys &> /dev/null
sudo umount /tmp/mountpoint/proc &> /dev/null
sudo umount /tmp/mountpoint/run &> /dev/null
set -e

sudo rm -rf /tmp/mountpoint
mkdir -pv upper/var/cache/alps/sources &> /dev/null
mkdir -pv work &> /dev/null
mkdir -pv /tmp/mountpoint &> /dev/null
mkdir -pv /tmp/mountpoint/{dev/pts,proc,sys,run} &> /dev/null

#sudo mount -v --bind /dev /tmp/mountpoint/dev &> /dev/null
#sudo mount -vt devpts devpts /tmp/mountpoint/dev/pts -o gid=5,mode=620 &> /dev/null
sudo mount -vt proc proc /tmp/mountpoint/proc &> /dev/null
sudo mount -vt sysfs sysfs /tmp/mountpoint/sys &> /dev/null
sudo mount -vt tmpfs tmpfs /tmp/mountpoint/run &> /dev/null

sudo mount -t overlay -olowerdir=/,upperdir=upper,workdir=work overlay /tmp/mountpoint

sudo mount -v --bind /dev /tmp/mountpoint/dev &> /dev/null
sudo mount -vt devpts devpts /tmp/mountpoint/dev/pts -o gid=5,mode=620 &> /dev/null

sudo chroot /tmp/mountpoint /bin/bash --login +h -e $SCRIPTS_DIR/$1.sh

sudo umount /tmp/mountpoint/dev/pts &> /dev/null
sudo umount /tmp/mountpoint/dev &> /dev/null

sudo umount /tmp/mountpoint

sudo umount /tmp/mountpoint/sys &> /dev/null
sudo umount /tmp/mountpoint/proc &> /dev/null
sudo umount /tmp/mountpoint/run &> /dev/null

cd upper
XZ_OPT=-9 sudo tar --exclude=etc/alps --exclude=var/cache/alps --exclude=tmp --exclude=etc/alps/installed-list -cJf $BINARY_DIR/$1.tar.xz *
cd ..

tar tf $1.tar.xz > $BINARY_DIR/$1.contents.temp

for line in `cat $BINARY_DIR/$1.contents.temp`
do

if [ ! -f $line ]
then
	echo $line >> $BINARY_DIR/$1.contents
else
	echo "#$line" >> $BINARY_DIR/$1.contents
fi

done

rm $BINARY_DIR/$1.contents.temp
sudo tar -x --skip-old-files -f $BINARY_DIR/$1.tar.xz -C /

#rm -rf temp
#mkdir temp
#tar xf $1.tar.gz -C temp
#cd temp
#for f in `find .`
#do
#	if [ "$f" == "." ]
#	then
#		continue
#	fi
#	ff=`echo $f | sed 's/^\.//g'`
#	#echo "Finding $f => $ff"
#	if [ -f $ff ]
#	then
#		# echo "$ff found"
#		if echo $ff | grep "^\/etc" &> /dev/null
#		then
#			if ! diff $ff $f &> /dev/null; then
#				echo "$ff appending"
#				cat $f | sudo tee -a $ff
#			fi
#		fi
#	fi
#done
#cd ..
#rm -rf temp

echo "$1=>`date`" | sudo tee -a /etc/alps/installed-list

if [ ! -e `ls upper/var/cache/alps/sources/` ]
then
cp -vf upper/var/cache/alps/sources/* /var/cache/alps/sources/
fi

sudo rm -rf upper
sudo rm -rf work
sudo rm -rf /tmp/mountpoint

popd

fi
