#!/bin/sh
#
# Store commit sha1 pair in the map.

cd ../map

mkdir -p ${1:0:2} ${2:0:2}
echo $1 > ${2:0:2}/${2:2}
echo $2 > ${1:0:2}/${1:2}

