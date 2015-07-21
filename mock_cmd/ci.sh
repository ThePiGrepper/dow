#!/bin/bash
#
# Generate CVS commits.
#
# First argument is the commit message. Following are the file paths to be
# updated.
#
# File contents are copied from the HEAD of the data repository. Files are
# unlocked after successful commits.

message=$1
shift

data_repo=../data
mock_repo=../mock_repo
utils=../utils

cd $data_repo

for file in "$@"; do
  if [ -e $mock_repo/$file/log ]; then
    version=`tail -n 1 $mock_repo/$file/log`
    version="$($utils/version_advance.sh ${version:1} 1)"
  else
    mkdir -p $mock_repo/$file
    version='1.1'
  fi
  echo $message > $mock_repo/$file/msg-${version}
  echo "A$version" >> $mock_repo/$file/log
  git show HEAD:$file > $mock_repo/$file/$version
done

