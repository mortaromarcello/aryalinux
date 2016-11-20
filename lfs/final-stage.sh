#!/bin/bash

set -e
set +h

cd /sources/

echo $1
echo $2

if ! grep "root-and-admin-passwords" /sources/build-log &> /dev/null
then

clear
echo "Setting the password for root :"
yes "$1" | passwd root

clear
echo "Setting the password for $USERNAME :"
yes "$2" | passwd $USERNAME

echo "Done with the build process. You may now exit by entering the following :"
echo ""
echo "exit"
echo ""

echo "root-and-admin-passwords" >> /sources/build-log

fi
