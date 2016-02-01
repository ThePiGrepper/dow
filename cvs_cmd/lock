#!/bin/bash
#
# Output if successful: List of latest versions of locked files, in the order
# given in the input, with the following format:
#   A1.5 : File is alive, and current version is 1.5
#   D1.5 : File is dead, and last version was 1.5
#   A1.0 : No version of the file in the repository.

#TODO: Handle retired files

cvs_repo=../cvs_repo
CVSROOT=$(awk -F "=" '/^CVS.ROOTPATH[ =]/{gsub(/[ \t]*/,"",$2);print $2}' ./config)

cd $cvs_repo

#cvs doesnt support lock natively, so this script also does not. Sorry
#but if it did , this would be the place.
for param in "$@"
do
  mkdir -p  $(dirname "$param")
done
cvs update -A $@

while (($#)); do
  out=$(cvs status $1)

  if echo "$out" | grep 'Status: Unknown' > /dev/null; then
    echo A1.0
  elif echo "$out" | grep 'Working revision:[[:space:]]\+[0-9]\+\(\.[0-9]\+\)*' > /dev/null; then
    echo "$out" | awk '/[ ]*Working revision:*/{print "A"$3}'
  else
    echo FAIL
    exit 1
  fi

  shift
done

