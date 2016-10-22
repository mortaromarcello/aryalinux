#!/bin/bash

set -e
set +h

. /sources/build-properties

cd /sources/

if ! grep "user-and-passwords" /sources/build-log &> /dev/null
then

clear
echo "Setting the password for root :"
passwd root

clear
echo "Creating user with name $FULLNAME and username : $USERNAME"
useradd -m -c "$FULLNAME" -s /bin/bash $USERNAME
echo "Setting the password for $USERNAME :"
passwd $USERNAME
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
groupadd wheel
usermod -a -G wheel $USERNAME

echo "Done with the build process. You may now exit by entering the following :"
echo ""
echo "exit"
echo ""

fi


