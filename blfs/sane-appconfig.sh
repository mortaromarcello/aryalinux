#!/bin/bash
set -e
set +h

if ! grep scanner /etc/group; then groupadd -g 70 scanner; fi

