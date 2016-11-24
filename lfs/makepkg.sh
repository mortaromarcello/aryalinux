#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

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

sudo chroot /tmp/mountpoint /bin/bash --login +h -e /var/cache/alps/scripts/$1.sh

sudo umount /tmp/mountpoint/dev/pts &> /dev/null
sudo umount /tmp/mountpoint/dev &> /dev/null

sudo umount /tmp/mountpoint

sudo umount /tmp/mountpoint/sys &> /dev/null
sudo umount /tmp/mountpoint/proc &> /dev/null
sudo umount /tmp/mountpoint/run &> /dev/null

cd upper
echo "Creating package..."
XZ_OPT=-9 sudo tar --exclude=etc/alps --exclude=var/cache/alps --exclude=tmp --exclude=etc/alps/installed-list -cJf $BINARY_DIR/$1.tar.xz *
cd ..

echo "Listing components..."
tar tf $BINARY_DIR/$1.tar.xz > $BINARY_DIR/$1.contents.temp

echo "Removing unwanted elements in components..."
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

echo "Installing..."
sudo tar -x --skip-old-files -f $BINARY_DIR/$1.tar.xz -C /

echo "$1=>`date`" | sudo tee -a $INSTALLED_LIST

if [ "$(ls -A upper/var/cache/alps/sources/)" ]
then
cp -rf upper/var/cache/alps/sources/* /var/cache/alps/sources/
fi

sudo rm -rf upper
sudo rm -rf work
sudo rm -rf /tmp/mountpoint

popd
