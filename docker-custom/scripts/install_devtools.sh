#!/bin/bash
set -ex

# Installing Devtools
if [[ ${TAG_SUFFIX} != "minimal" ]]; then
  echo "Installing devtools"
  apk add --no-cache --virtual devtools build-base linux-headers udev python2 python3
else
  echo "Skip installing devtools"
fi
