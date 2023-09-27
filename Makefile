SILENT= > /dev/null
SHELL := /usr/bin/env bash -eo pipefail -c

define PREPARE_ENV
	source ./.github/gen_env.sh;
endef

###############################################

deploy.infra:
	@echo 'Deploying infra'
	${PREPARE_ENV} \
		./infra/tfinit && \
		./infra/tfrun apply -y

###############################################

mr.clean:
	@echo 'Clean Environment'
	@${PREPARE_ENV} \
		if [ $${STAGE} == "prod" ]; \
		then \
			echo "We don't clean PRODUCTION :)"; \
		else \
			./infra/tf.sh destroy -y && \
		fi \
