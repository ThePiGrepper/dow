#!/bin/sh
#
# Apply commit to repository $1, copying info from HEAD of the current one.

message=`git log -1 --format=format:%B HEAD`
GIT_AUTHOR_NAME=`git log -1 --format=format:%an HEAD`
GIT_AUTHOR_EMAIL=`git log -1 --format=format:%ae HEAD`
GIT_AUTHOR_DATE=`git log -1 --format=format:%ad HEAD`
GIT_COMMITTER_NAME=`git log -1 --format=format:%cn HEAD`
GIT_COMMITTER_EMAIL=`git log -1 --format=format:%ce HEAD`
# Use automatic GIT_COMMITTER_DATE.

cd $1
git commit -m "$message" --no-verify --allow-empty

