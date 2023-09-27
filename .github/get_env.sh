#!/usr/bin/env bash

set -eo pipefail -c

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

pushd $DIR/../ >/dev/null

if [ -z "${STAGE}" ]; then

  RUNS_ON_GITHUB=true
  if [ -z "${GITHUB_ENV}" ]; then
    RUNS_ON_GITHUB=false
  fi

  REF_NAME=""
  if [ "$#" -ne 1 ]; then
    REF_NAME=$(git rev-parse --abbrev-ref HEAD)
  else
    REF_NAME=$1
  fi

  REF_COMMIT=""
  if [ "$#" -ne 1 ]; then
    REF_COMMIT=$(git log -1 | grep ^commit | cut -d " " -f 2)
  else
    REF_COMMIT=$1
  fi

  SHA=""
  if [ "$#" -ne 1 ]; then
    SHA=$(echo $REF_NAME | sed 's|refs/heads/||' | md5sum - | cut -d ' ' -f1 | head -c 8)
  else
    SHA=$1
  fi

  if [ "$(echo $REF_NAME | sed 's|refs/heads/||')" == "main" ]; then
    export "STAGE=prod"
    export "CURRENT_BRANCH=$REF_NAME"
    export "TAG=prod-$REF_COMMIT"
  else
    export "STAGE=$SHA"
    export "CURRENT_BRANCH=$REF_NAME"
    export "TAG=$SHA-$REF_COMMIT"
  fi

  if [ "$RUNS_ON_GITHUB" = true ]; then
    grep "$STAGE" $GITHUB_ENV >/dev/null || (echo "STAGE=$STAGE" >>$GITHUB_ENV)
  fi
  printf "STAGE=%s\n" $STAGE
  printf "CURRENT_BRANCH=%s\n" $CURRENT_BRANCH
  printf "TAG=%s\n" $TAG
fi

for dir in infra
do
  pushd $dir >/dev/null ;
      envsubst < ci-vars.tfvars.json.tpl > "data/$STAGE.tfvars.json";
  popd >/dev/null ;
done

popd >/dev/null
