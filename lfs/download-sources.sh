#!/bin/bash

set -e
set +h

mkdir -pv ../sources
cp wget-list ../sources
cd ../sources
wget -nc -i wget-list
