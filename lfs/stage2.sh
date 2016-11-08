#!/bin/bash

set -e

. /sources/build-properties

for script in /sources/toolchain/*.sh
do

bash $script | tee /sources/logs/$script.log

done

