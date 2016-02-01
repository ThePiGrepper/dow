#!/bin/bash
#
# Abort procedure of dow-sync-base
#
# Usage: $0
#
# Erases auxiliary files and reverts state.
#
# As a proviso, the result file 'dow-sync-base-result' is kept, so that the
# partial or final result of the last invocation can be analysed.
#
# State:
#   dow-sync-base-MERGE_HEAD : Original MERGE_HEAD if any
#   dow-sync-base-MERGE_MODE : Original MERGE_MODE if any
#   versions/.git/MERGE_HEAD : Current base candidate
#   dow-sync-base-range : Range to be searched
#   dow-sync-base-skip_base : Oldest bad commit in the range if any
#   dow-sync-base-result : Best synchronisation bases so far

dow_root=`pwd`
versions_repo=$dow_root/versions

cd $versions_repo

if ! [ -e ../dow-sync-base-range ]; then
  echo 'fatal: There is no dow-sync-base to abort (dow-sync-base-range is missing).'
  exit 128
fi

if [ -e .git/MERGE_HEAD ]; then
  git merge --abort
fi

git reset --soft HEAD^

# Restore MERGE_HEAD and MERGE_MODE.
if [ -e ../dow-sync-base-MERGE_HEAD ]; then
  mv ../dow-sync-base-MERGE_HEAD .git/MERGE_HEAD
fi
if [ -e ../dow-sync-base-MERGE_MODE ]; then
  mv ../dow-sync-base-MERGE_MODE .git/MERGE_MODE
fi

rm -f ../dow-sync-base-{range,skip_base}

