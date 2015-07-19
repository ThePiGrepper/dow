#!/bin/sh
#
# Return data commit corresponding to given versions commit.

cat ../map/${1:0:2}/${1:2}
ret=$?

if ! [ $ret -eq 0 ]; then
  echo 'Could not retrieve data commit corresponding to versions commit $1.'
fi

exit $ret

