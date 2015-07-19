#!/bin/sh
#
# Check if index and local tree are clean.

if git rev-parse --quiet --verify HEAD; then
  against=HEAD
else
  # Initial commit: diff against an empty tree object.
  against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

if ! git diff-index --quiet --cached $against; then
  # Index not clean
  exit 1;
elif ! git diff-files --quiet; then
  # Working area not clean
  exit 1;
fi

