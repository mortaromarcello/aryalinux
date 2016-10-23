#!/bin/bash

set -e
set +h

. /sources/build-properties

cd /sources/

if ! grep "root-and-admin-passwords" /sources/build-log &> /dev/null
then

clear
echo "Setting the password for root :"
passwd root

clear
echo "Setting the password for $USERNAME :"
passwd $USERNAME

echo "Done with the build process. You may now exit by entering the following :"
echo ""
echo "exit"
echo ""

echo "root-and-admin-passwords" >> /sources/build-log

fi
