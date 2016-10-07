#!/bin/bash

set -e
set +h

. /sources/build-properties

for SCRIPT in toolchain/*.sh
do
	$SCRIPT
done

clear
echo "Fatto tutto: il toolchain è stato creato."
echo "Premi exit per continuare..."
