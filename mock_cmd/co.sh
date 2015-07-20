#!/bin/bash
#
# Copy contents of file $1, version $2, into data repository.

file=$1
version=$2
data_repo=../data

cd "$data_repo"
mkdir -p $(dirname $file)
echo "$file;$version" > $data_repo/$file

