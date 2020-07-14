#!/bin/bash

set -e

SZIP="szip-${SZIP_VERSION}"
dir="${DEPS_DIR}/szip"

if [ ! -d "${dir}" ]; then
    wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$SZIP.tgz -O $SZIP.tgz
    tar xvfz $SZIP.tgz
    rm -f $SZIP.tgz
    mv "${SZIP}" "szip"
fi
