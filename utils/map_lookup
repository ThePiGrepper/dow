#!/bin/bash
#
# Lookup commit corresponding to the one given in the map.

cat ../map/${1:0:2}/${1:2}
ret=$?

if ! [ $ret -eq 0 ]; then
  echo 'Could not retrieve commit mirroring $1.'
fi

exit $ret

