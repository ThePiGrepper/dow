#!/bin/bash
#
# Checkout and setup merge heads according to source.

branch=$1
source_repo=$2
source_has_head=$3
source_head_commit=$4

utils=../utils

if ! $utils/check_clean_status.sh; then
  echo "Repository $(pwd) status not clean."
  exit 1
fi

if [ $source_has_head -eq 0 ]; then
  mapped_head_commit=`$utils/map_lookup.sh $source_head_commit`
  if ! [ $? -eq 0 ]; then
    exit 1
  fi
fi

# Checkout.
if git rev-parse --quiet --verify $branch > /dev/null; then
  git checkout $branch
elif [ $source_has_head -eq 0 ]; then
  git checkout -b $branch $mapped_head_commit
else
  git checkout --orphan $branch
  git rm -rf . 2> /dev/null
fi

# Assert that the branch is synchronized.
# TODO: Rollback on failure.
head_commit=`git rev-parse --quiet --verify HEAD`
has_head=$? # 0 means yes.
if [ $source_has_head -eq 0 ]; then
  if ! [ $has_head -eq 0 ]; then
    echo "Branch $branch not synchronized."
    echo "In data, expected $mapped_head_commit, but found no commit."
    exit 1
  fi
  if ! [ $head_commit == $mapped_head_commit ]; then
    echo "Branch $branch not synchronized."
    echo "In data, expected $mapped_head_commit, but found $head_commit."
    exit 1
  fi
else
  if [ $has_head -eq 0 ]; then
    echo "Branch $branch not synchronized."
    echo "In data, expected no commit, but found HEAD=$head_commit."
    exit 1
  fi
fi

# Assert that status is still clean after checkout.
# TODO: Rollback on failure.
if ! $utils/check_clean_status.sh; then
  echo "Repository $(pwd) status not clean."
  exit 1
fi

# Translate MERGE_HEAD.
if [ -e $source_repo/.git/MERGE_HEAD ]; then
  > .git/MERGE_HEAD
  while read -r p; do
    $utils/map_lookup.sh $p >> .git/MERGE_HEAD || exit 1
  done < $source_repo/.git/MERGE_HEAD
else
  rm -f .git/MERGE_HEAD
fi

# Copy MERGE_MODE
if [ -e $source_repo/.git/MERGE_MODE ]; then
  cp $source_repo/.git/MERGE_MODE .git/
fi

