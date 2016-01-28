#!/bin/bash
#
# Put contents of file $1, version $2, into data repository.

file=$1
version=$2
data_repo=../data
cvs_repo=../cvs_repo
CVSROOT=$(awk -F "=" '/^CVS.ROOTPATH[ =]/{gsub(/[ \t]*/,"",$2);print $2}' ./config)

cd $cvs_repo

cvs update -r $version $file
#> /dev/null/ 2>&1
if [ ! -f $file ]; then
  echo "Version $version of $file not available."
  exit 1
fi

mkdir -p "$data_repo/$(dirname $file)"
cp -f "$file" "$data_repo/$file"
