#!/bin/bash
#
# Delete files in the CVS repository. Unlock if successful.
CVSROOT=$(awk -F "=" '/^CVS.ROOTPATH[ =]/{gsub(/[ \t]*/,"",$2);print $2}' ./config)
cd ../cvs_repo
message=$1
shift

cvs remove -f "$@"
cvs commit -m "$message"
