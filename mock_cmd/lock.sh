#!/bin/bash
#
# Output if successful: List of latest versions of locked files, in the order
# given in the input, with the following format:
#   A1.5 : File is alive, and current version is 1.5
#   D1.5 : File is dead, and last version was 1.5
#   A1.0 : No version of the file in the repository.

cd ../mock_repo
for file in "$@"; do
  if [ -e "$file" ]; then
    tail -n 1 "$file"
  else
    echo A1.0
  fi
done

