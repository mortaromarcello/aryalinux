#!/bin/bash

set -e
set +h

mkdir -pv ../sources
cp wget-list ../sources
cd ../sources
wget -c -i wget-list
