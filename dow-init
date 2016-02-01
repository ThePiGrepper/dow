#!/bin/bash
#
# Initialize a mirrored repository.

git init versions
git init data
mkdir map
mkdir $1_repo

ln -s srcdir/utils .
ln -s srcdir/$1_cmd cvs_cmd

cd versions/.git/hooks
ln -s ../../../srcdir/hooks/versions/pre-commit .
ln -s ../../../srcdir/hooks/versions/commit-msg .
ln -s ../../../srcdir/hooks/versions/post-commit .

cd ../../../data/.git/hooks
ln -s ../../../srcdir/hooks/data/pre-commit .
ln -s ../../../srcdir/hooks/data/post-commit .

