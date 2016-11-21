#!/bin/bash

set -e
set +h

cd /sources/
. ./build-properties

if ! grep "root-and-admin-passwords" /sources/build-log &> /dev/null
then

echo "Setting the password for root :"
yes "$1" | passwd

echo "Setting the password for $USERNAME :"
yes "$2" | passwd "$USERNAME"

echo "Done with the build process. You may now exit by entering the following :"
echo ""
echo "exit"
echo ""

echo "root-and-admin-passwords" >> /sources/build-log

fi
