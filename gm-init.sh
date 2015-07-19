#!/bin/sh
#
# Initialize a gm mirrored repository.

git init versions
git init data
mkdir map

ln -s gm_draft/utils .

cd versions/.git/hooks
ln -s ../../../gm_draft/hooks/versions/pre-commit .
ln -s ../../../gm_draft/hooks/versions/post-commit .

