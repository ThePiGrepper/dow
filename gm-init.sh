#!/bin/sh
#
# Initialize a gm mirrored repository.

git init versions
git init data
mkdir map

ln -s gm_draft/utils .
ln -s gm_draft/$1_cmd cvs_cmd

cd versions/.git/hooks
ln -s ../../../gm_draft/hooks/versions/pre-commit .
ln -s ../../../gm_draft/hooks/versions/post-commit .

