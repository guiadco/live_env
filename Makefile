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

###############################################

mr.clean:
	@echo 'Clean Environment'
	@${PREPARE_ENV} \
		if [ $${STAGE} == "prod" ]; \
		then \
			echo "We don't clean PRODUCTION :)"; \
		else \
			./infra/tf.sh destroy && \
		fi \
