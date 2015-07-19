#!/bin/bash
#
# Initialize a gm mirrored repository.

git init versions
git init data
mkdir map
mkdir $1_repo

ln -s gm_draft/utils .
ln -s gm_draft/$1_cmd cvs_cmd

cd versions/.git/hooks
ln -s ../../../gm_draft/hooks/versions/pre-commit .
ln -s ../../../gm_draft/hooks/versions/commit-msg .
ln -s ../../../gm_draft/hooks/versions/post-commit .

cd ../../../data/.git/hooks
ln -s ../../../gm_draft/hooks/data/pre-commit .
ln -s ../../../gm_draft/hooks/data/post-commit .

