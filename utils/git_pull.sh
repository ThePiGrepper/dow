#!/bin/bash
#
# To be called from data repository.
#
# Pull from source while updating versions repository. Only fast-forwards
# allowed.

data_repo=../data
versions_repo=../versions
cvs_repo=../cvs_repo
utils=../utils
cvs_cmd=../cvs_cmd

source=$1
branch=$2

if ! $utils/check_clean_status.sh; then
  echo "Repository $(pwd) status not clean."
  exit 1
fi

git fetch --force $source $branch:detail/$branch

if git rev-parse --quiet --verify $branch > /dev/null; then
  if ! git merge-base --is-ancestor $branch detail/$branch; then
    echo "Error: Non fast-forward."
    exit 1
  fi
  base="^$branch"
else
  base= #empty
fi

while read commit parent merge_parents; do
  if [ -n "$parent" ]; then
    against=$parent
  else
    # Initial commit: diff against an empty tree object.
    against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
  fi

  delete=`git diff --diff-filter=D --name-only $against $commit`
  add=`git diff --diff-filter=A --name-only $against $commit`
  modify=`git diff --diff-filter=M --name-only $against $commit`
  message=`git log -1 --format=format:%B $commit`

  git checkout $commit

  cd $versions_repo

  if ! $utils/git_checkout_pull.sh detail/$branch $parent $merge_parents; then
    exit 1
  fi

  if [ -z "$delete$add$modify" ]; then
    # Empty commit. Nothing to do here.
    exit 0
  fi

  # TODO: Take other parents into account.
  #       For now, we require that the files in the main parent are synchronized
  #       or not modified.

  # Begin: Locks and checks
  version_array=( `$cvs_cmd/lock.sh $delete $add $modify` )
  if ! [ $? -eq 0 ]; then
    $cvs_cmd/unlock.sh $delete $add $modify
    exit 1
  fi

  delete_array=( $delete )
  add_array=( $add )
  modify_array=( $modify )

  if ! [ ${#version_array[@]} -eq $(( ${#delete_array[@]} + ${#add_array[@]} + ${#modify_array[@]} )) ]; then
    echo "Oops. Array sizes mismatch: ${#version_array[@]} != ${#delete_array[@]} + ${#add_array[@]} + ${#modify_array[@]}"
    $cvs_cmd/unlock.sh $delete $add $modify
    exit 1
  fi

  i=0
  d=${#delete_array[@]}
  a=$((d + ${#add_array[@]}))
  m=$((a + ${#modify_array[@]}))
  mismatch=0
  for (( ; i < d; ++i)); do # Removes
    expected="A`git show HEAD:${delete_array[i]}`"
    if ! [ ${version_array[i]} == $expected ]; then
      echo "Version mismatch: $expected < ${version_array[i]} ${delete_array[i]}"
      mismatch=1
    fi
  done
  for (( ; i < a; ++i)); do # Adds
    # TODO: Consider file ressurrection.
    expected="A1.0"
    if ! [ ${version_array[i]} == $expected ]; then
      echo "Version mismatch: $expected < ${version_array[i]} ${add_array[$((i-d))]}"
      mismatch=1
    fi
  done
  for (( ; i < m; ++i)); do # Modifies
    expected="A`git show HEAD:${modify_array[$((i-a))]}`"
    if ! [ ${version_array[i]} == $expected ]; then
      echo "Version mismatch: $expected < ${version_array[i]} ${modify_array[$((i-a))]}"
      mismatch=1
    fi
  done

  if [ $mismatch -ne 0 ]; then
    $cvs_cmd/unlock.sh $delete $add $modify
    exit 1;
  fi
  # End: Locks and checks

  # Apply removes.
  if [ -n "$delete" ]; then
    $cvs_cmd/rm.sh "$message" $delete
    git rm $delete
  fi

  # Apply additions.
  for file in $add; do
    mkdir -p $(dirname $file)
    # TODO: Consider file ressurrection.
    echo 1.1 > $file
  done

  # Apply modifications.
  for file in $modify; do
    mkdir -p $(dirname $file)
    $utils/version_advance.sh `git show :0:$file` 1 > $file
  done

  if [ -n "$add$modify" ]; then
    $cvs_cmd/ci.sh "$message" $add $modify
    git add $add $modify
  fi

  cd $data_repo

  touch ../modification_commit
  $utils/git_commit_to_other.sh $versions_repo
done <<<"$(git rev-list --reverse --parents detail/$branch $base)"

# Checkout.
if git rev-parse --quiet --verify $branch > /dev/null; then
  git checkout $branch
else
  git checkout --orphan $branch
  git rm -rf . 2> /dev/null
fi

git merge detail/$branch
git branch -d detail/$branch

cd $versions_repo

# Checkout.
if git rev-parse --quiet --verify $branch > /dev/null; then
  git checkout $branch
else
  git checkout --orphan $branch
  git rm -rf . 2> /dev/null
fi

git merge detail/$branch
git branch -d detail/$branch

