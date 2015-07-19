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

utils=../utils

cd ../mock_repo

for file in "$@"; do
  if [ -e $file ]; then
    version=`tail -n 1 $file`
    version="A$($utils/version_advance.sh ${version:1} 1)"
  else
    mkdir -p $(dirname $file)
    version='A1.1'
  fi
  echo $message >> $file
  echo $version >> $file
done

