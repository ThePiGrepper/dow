#!/bin/bash
#
# Put contents of file $1, version $2, into data repository.

file=$1
version=$2
data_repo=../data
mock_repo=../mock_repo
utils=../utils

if ! [ -e "$mock_repo/$file/$version" ]; then
  echo "Version $version of $file not available."
  exit 1
fi

mkdir -p "$data_repo/$(dirname $file)"
cp "$mock_repo/$file/$version" "$data_repo/$file"

