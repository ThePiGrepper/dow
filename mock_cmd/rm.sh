#!/bin/bash
#
# Delete files in the CVS repository. Unlock if successful.

cd ../mock_repo

for file in "$@"; do
  if [ -e $file ]; then
    version=`tail -n 1 $file`
    echo "D${version:1}" >> $file
  fi
done

