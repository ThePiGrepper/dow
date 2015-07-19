#!/bin/bash
#
# Put contents of file $1, version $2, into data repository.

file=$1
version=$2
data_repo=../data
mock_repo=../mock_repo
utils=../utils

cd "$mock_repo"

if ! [ -e $file ]; then
  echo "File $file not present."
  exit 1
fi

cur_version=`tail -n 1 $file`
cur_version=${cur_version:1}
dist=`$utils/version_distance.sh $version $cur_version`
if ! [ $? -eq 0 ]; then
  exit 1
elif [ $dist -lt 0 ]; then
  echo "Version $version of $file not available (Latest=$cur_version)."
  exit 1
fi

cd "$data_repo"
mkdir -p $(dirname $file)
echo "$file;$version" > $data_repo/$file

