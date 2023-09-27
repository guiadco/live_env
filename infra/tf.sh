#!/usr/bin/env bash

set -eu

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
TERRAFORM_DIR="${DIR}/terraform"


echo "Workspace: ${STAGE}"

pushd "${TERRAFORM_DIR}" >/dev/null
terraform init \
  -reconfigure
terraform workspace select "${STAGE}" ||
  terraform workspace new "${STAGE}"
terraform init \
  -reconfigure
popd >/dev/null

set -eu

pushd "${TERRAFORM_DIR}" >/dev/null
CURRENT_WORKSPACE=$(terraform workspace show)
popd

PLAN_FILE=$(mktemp)
TERRAFORM_ACTION=""
TF_APPLY_ARGS=""
TF_PLAN_ARGS=""
TF_AUTO_APPROVE=0

if [ $# -eq 0 ]; then
  echo "Usage : tfrun (apply|destroy) [-y]"
  exit 1
fi

while [[ $# -gt 0 ]]; do
  key="${1}"
  case "${key}" in
  apply)
    TERRAFORM_ACTION="apply"
    TF_APPLY_ARGS="${PLAN_FILE}"
    echo "${TF_APPLY_ARGS}"
    shift
    ;;
  destroy)
    TERRAFORM_ACTION="apply"
    TF_APPLY_ARGS="${PLAN_FILE}"
    TF_PLAN_ARGS="-destroy"
    shift
    ;;
  -y)
    TF_APPLY_ARGS="-auto-approve $TF_APPLY_ARGS"
    TF_AUTO_APPROVE=1
    shift
    ;;
  *)
    TERRAFORM_ACTION="$@"
    shift
    ;;
  esac
done

if [ -z "$TERRAFORM_ACTION" ]; then
  echo "action not specified"
  exit 1
fi


pushd "${TERRAFORM_DIR}" >/dev/null
terraform \
  plan \
  ${TF_PLAN_ARGS} \
  -var-file "${DIR}/data/${CURRENT_WORKSPACE}.tfvars.json" \
  -out "${PLAN_FILE}"

if [ ${TF_AUTO_APPROVE} -eq 0 ]; then
  echo "You are deploying the ${CURRENT_WORKSPACE} environment with the plan above."
  read -rp "Confirm ? [Y/n]" confirmation

  if [ -z "${confirmation}" ] || [ "$(echo "${confirmation}" | cut -c1 | tr '[:upper:]' '[:lower:]')" = "y" ]; then
    echo "Confirmed, applying plan"
  else
    echo "Aborted"
    exit 0
  fi
fi
if [ "${TF_PLAN_ARGS}" = "-destroy" ]; then
  terraform ${TERRAFORM_ACTION} ${TF_APPLY_ARGS} || true
  terraform \
    plan \
    ${TF_PLAN_ARGS} \
    -var-file "${DIR}/data/${CURRENT_WORKSPACE}.tfvars.json" \
    -out "${PLAN_FILE}"
  terraform ${TERRAFORM_ACTION} ${TF_APPLY_ARGS}
else
  terraform ${TERRAFORM_ACTION} ${TF_APPLY_ARGS}
fi
popd >/dev/null
