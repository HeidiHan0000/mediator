#!/bin/bash
#
# Copyright SecureKey Technologies Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

echo "Running $0"

DOCKER_CMD=${DOCKER_CMD:-docker}
GOLANGCI_LINT_IMAGE="golangci/golangci-lint:v1.39.0"


if [ ! $(command -v ${DOCKER_CMD}) ]; then
    exit 0
fi

${DOCKER_CMD} run --rm -e GOPROXY=${GOPROXY} -v $(pwd):/opt/workspace -w /opt/workspace ${GOLANGCI_LINT_IMAGE} golangci-lint run
${DOCKER_CMD} run --rm -e GOPROXY=${GOPROXY} -v $(pwd):/opt/workspace -w /opt/workspace/cmd/mediator ${GOLANGCI_LINT_IMAGE} golangci-lint run -c ../../.golangci.yml --path-prefix "cmd/mediator/"
${DOCKER_CMD} run --rm -e GOPROXY=${GOPROXY} -v $(pwd):/opt/workspace -w /opt/workspace/test/bdd ${GOLANGCI_LINT_IMAGE} golangci-lint run -c ../../.golangci.yml --path-prefix "test/bdd/"
