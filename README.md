# Live environment

When talking about infrastructure, a "live environment" (also known as a "production environment") refers to the actual infrastructure that supports and runs the live applications or services that end-users or customers access and use.

This repository contains the Terraform or OpenTofu code to create the live environment:

- **Only** Compatible with Github
- Create live environment variables
  - Default variables
    - `STAGE`: Stage tag for the environment
- Initialize Terraform or OpenTofu

Exposed variables during the deployment:

```
STAGE=prod
CURRENT_BRANCH=main
TAG=prod-39e58ad258288cc8a0013fac8a80552ac511c619
```

## How to use

- Clone this repository
- Add your own Terraform or OpenTofu code to infra/terraform
- Add your default variables to infra/terraform/variables.tf
- Add your your live environment variables to infra/ci-vars.tfvars.json.tpl

```
make infra.init
make infra.plan
make infra.apply
make infra.destroy
```
