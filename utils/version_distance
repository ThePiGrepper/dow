#!/bin/bash
#
# Output distance between first and second revision. Fail if prefixes do not
# match.
#
# Result corresponds to $2 - $1. That means it is positive iff $1 precedes $2.

if ! [ "${1%.*}" == "${2%.*}" ]; then
  echo "Prefix mismatch: ${1%.*} != ${2%.*}"
  exit 1
fi

echo $((${2##*.} - ${1##*.}))

