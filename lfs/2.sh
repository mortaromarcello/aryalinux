#!/bin/bash

set -e
set +h

. /sources/build-properties

for SCRIPT in toolchain/*.sh
do
	$SCRIPT
done

clear
echo "Done with building the toolchain."
echo "Enter exit to continue..."
