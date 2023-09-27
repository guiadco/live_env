#!/usr/bin/env bash

set -eu

PLAN_FILE=$(mktemp)
TERRAFORM_ACTION=""
TF_AUTO_APPROVE=0
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
TERRAFORM_DIR="${DIR}/terraform"

## First define if workspace exists or not
printf "Workspace: %s" $STAGE
pushd "${TERRAFORM_DIR}" >/dev/null
terraform workspace select "${STAGE}" ||  terraform workspace new "${STAGE}"
terraform init -reconfigure

printf "Workspace done: %s\n" $(terraform workspace show)

## Apply terraform

CURRENT_WORKSPACE=$(terraform workspace show)

if [ "${CURRENT_WORKSPACE}" != "${STAGE}" ]; then
  echo "Workspace mismatch: ${CURRENT_WORKSPACE} != ${STAGE}"
  exit 1
fi

function usage() {
    printf "Usage : %s(apply|destroy)\n" $0
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
        ;;
    destroy)
        TERRAFORM_ACTION="destroy"
        ;;
    *)
        echo "Invalid action: $1"
        usage
        ;;
esac

printf "Action: %s\n" $TERRAFORM_ACTION

terraform ${TERRAFORM_ACTION} --auto-approve -var-file="../data/${STAGE}.tfvars.json"

popd >/dev/null
