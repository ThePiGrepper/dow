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
cvs_repo=../cvs_repo
CVSROOT=$(awk -F "=" '/^CVS.ROOTPATH[ =]/{gsub(/[ \t]*/,"",$2);print $2}' ./config)

cd $data_repo

for file in "$@"; do
  git show HEAD:$file > $cvs_repo/$file
done

cd $cvs_repo
cvs add "$@"
#> /dev/null/ 2>&1
cvs commit -m "$message"
