# Live environment

When talking about infrastructure, a "live environment" (also known as a "production environment") refers to the actual infrastructure that supports and runs the live applications or services that end-users or customers access and use.

This repository contains the Terraform or OpenTofu code to create the live environment:

- **Only** Compatible with Github
- Create live environment variables
  - Default variables
    - `STAGE`: Stage tag for the environment
- Initialize Terraform or OpenTofu
- Stored backend state in remote place (S3 bucket)
