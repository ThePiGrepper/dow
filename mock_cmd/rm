#!/bin/bash
#
# Delete files in the CVS repository. Unlock if successful.
#
# First argument is the commit message. Following are the file paths to be
# removed.

message=$1
shift

cd ../mock_repo

for file in "$@"; do
  if [ -e $file/log ]; then
    version=`tail -n 1 $file/log`
    version="D${version:1}"
    echo "$message" >> $file/msg-$version
    echo $version >> $file/log
  fi
done

