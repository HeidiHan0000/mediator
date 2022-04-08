# Copyright SecureKey Technologies Inc.
#
# SPDX-License-Identifier: Apache-2.0

# Namespace for the docker images
DOCKER_OUTPUT_NS   ?= ghcr.io
DOCKER_IMAGE_NAME ?= trustbloc/mediator
MOCK_WEBHOOK_IMAGE_NAME ?= trustbloc/mock-webhook

# Tool commands (overridable)
ALPINE_VER ?= 3.12
GO_VER ?= 1.16

.PHONY: all
all: checks unit-test bdd-test

.PHONY: checks
checks: license lint

.PHONY: lint
lint:
	@scripts/check_lint.sh

.PHONY: license
license:
	@scripts/check_license.sh

.PHONY: unit-test
unit-test:
	@scripts/check_unit.sh

.PHONY: bdd-test
bdd-test: clean test-keys mediator-docker mock-webhook-docker
	@scripts/check_integration.sh

.PHONY: test-keys
test-keys: clean
	@mkdir -p -p test/bdd/fixtures/keys/tls
	@docker run -i --rm \
		-v $(abspath .):/opt/workspace/mediator \
		--entrypoint "/opt/workspace/mediator/scripts/generate_test_keys.sh" \
		frapsoft/openssl

.PHONY: mediator-docker
mediator-docker:
	@echo "Building mediator docker image"
	@docker build -f ./images/mediator/Dockerfile --no-cache \
	   -t $(DOCKER_OUTPUT_NS)/$(DOCKER_IMAGE_NAME):latest \
	   --build-arg ALPINE_VER=$(ALPINE_VER) \
	   --build-arg GO_VER=$(GO_VER) .

.PHONY: mediator
mediator:
	@echo "Building mediator"
	@mkdir -p ./.build/bin
	@cd cmd/mediator && go build -o ../../.build/bin/mediator main.go

.PHONY: mock-webhook
mock-webhook:
	@echo "Building mock webhook server"
	@mkdir -p ./build/bin
	@cd test/mock/cmd/webhook && go build -o ../../../../build/bin/webhook-server ./main.go

.PHONY: mock-webhook-docker
mock-webhook-docker:
	@echo "Building mock webhook server docker image"
	@docker build -f ./test/mock/images/webhook/Dockerfile --no-cache -t $(DOCKER_OUTPUT_NS)/$(MOCK_WEBHOOK_IMAGE_NAME):latest \
	--build-arg GO_VER=$(GO_VER) \
	--build-arg ALPINE_VER=$(ALPINE_VER) \
	--build-arg GO_TAGS=$(GO_TAGS) \
	--build-arg GOPROXY=$(GOPROXY) .

.PHONY: clean
clean:
	@rm -Rf ./.build
	@rm -Rf ./test/bdd/fixtures/keys/tls
	@rm -Rf ./test/bdd/docker-compose.log


