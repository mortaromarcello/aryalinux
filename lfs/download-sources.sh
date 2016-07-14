#!/bin/bash

set -e
set +h

cp wget-list /sources
cd /sources
wget -c -i wget-list
