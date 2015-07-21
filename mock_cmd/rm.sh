#!/bin/bash
#
# Delete files in the CVS repository. Unlock if successful.

cd ../mock_repo

for file in "$@"; do
  if [ -e $file/log ]; then
    version=`tail -n 1 $file/log`
    echo "D${version:1}" >> $file/log
  fi
done

