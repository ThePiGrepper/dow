#!/bin/sh
#
# Return versions commit corresponding to given data commit.

cat ../map/${1:0:2}/${1:2}
ret=$?

if ! [ $ret -eq 0 ]; then
  echo 'Could not retrieve versions commit corresponding to data commit $1.'
fi

exit $ret

