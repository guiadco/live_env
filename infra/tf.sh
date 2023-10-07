#!/usr/bin/env bash

set -eu

find_command() {
  for cmd in "$@"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      echo "$cmd"
      return
    fi
  done
}

COMMAND=$(find_command "terraform" "opentofu")

if [ -z "$COMMAND" ]; then
  echo "Neither terraform nor opentofu is installed."
else
  echo "$COMMAND is installed."
fi

TERRAFORM_ACTION=""
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
TERRAFORM_DIR="${DIR}/terraform"
printf "Command: %s\n" $COMMAND

## First define if workspace exists or not
printf "Workspace: %s" $STAGE
pushd "${TERRAFORM_DIR}" >/dev/null
$COMMAND init -reconfigure
$COMMAND workspace select "${STAGE}" || $COMMAND workspace new "${STAGE}"
$COMMAND init -reconfigure

printf "Workspace done: %s\n" $($COMMAND workspace show)

## Apply terraform

CURRENT_WORKSPACE=$($COMMAND workspace show)

if [ "${CURRENT_WORKSPACE}" != "${STAGE}" ]; then
  printf "Workspace mismatch: %s != %s" $CURRENT_WORKSPACE $STAGE
  exit 1
fi

function usage() {
  printf "Usage : %s(apply|destroy|plan)\n" $0
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

# Check for action after removing options
if [ $# -eq 0 ]; then
  echo "action not specified"
  exit 1
fi

case "$1" in
apply)
  TERRAFORM_ACTION="apply"
  EMOJI="🚀"
  ;;
destroy)
  TERRAFORM_ACTION="destroy"
  EMOJI="🔥"
  ;;
plan)
  TERRAFORM_ACTION="plan"
  EMOJI="📝"
  ;;
*)
  echo "Invalid action: $1"
  usage
  ;;
esac

printf "Action: %s %s\n" $EMOJI $TERRAFORM_ACTION

if [ $TERRAFORM_ACTION == "plan" ]; then
  $COMMAND ${TERRAFORM_ACTION} -var-file "${DIR}/data/${STAGE}.tfvars.json" -out "${DIR}/plan/out.plan"
else
  $COMMAND ${TERRAFORM_ACTION} --auto-approve -var-file="${DIR}/data/${STAGE}.tfvars.json"
fi

popd >/dev/null
