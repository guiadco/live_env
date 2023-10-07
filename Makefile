SILENT= > /dev/null
SHELL := /usr/bin/env bash -eo pipefail -c

define PREPARE_ENV
	source ./.github/gen_env.sh;
endef

###############################################

pre-commit.install:
	@pre-commit install && \
		pre-commit install --hook-type commit-msg

###############################################

infra.init:
	@printf "InitDeploying infrastructure...\n"
	${PREPARE_ENV} \
		./infra/tf.sh

infra.apply:
	@printf "Deploying infrastructure...\n"
	${PREPARE_ENV} \
		./infra/tf.sh apply

infra.destroy:
	@printf "Destroy infrastructure...\n"
	${PREPARE_ENV} \
		./infra/tf.sh destroy

infra.plan:
	@printf "Plan infrastructure...\n"
	${PREPARE_ENV} \
		./infra/tf.sh plan

###############################################

build:
	@printf "Build...\n"
	@pushd ./live && \
		go build -o live live.go && \
		chmod +x live && \
		popd

###############################################

mr.clean:
	@printf "Clean Environment...\n"
	@${PREPARE_ENV} \
		if [ $${STAGE} == "prod" ]; \
		then \
			echo "We don't clean PRODUCTION :)"; \
		else \
			./infra/tf.sh destroy && \
			rm -rf ./infra/terraform/.terraform && \
			rm -rf ./infra/terraform/terraform.tfstate* && \
			rm -rf ./infra/terraform/terraform.lock.hcl && \
			rm -rf ./infra/plan/out.plan; \
		fi \
