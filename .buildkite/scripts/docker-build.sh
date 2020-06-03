#!/bin/bash

set -euo pipefail

export DOCKER_BUILD_OPTIONS="--build-arg LICENSE=${LICENSE}"

curl -fsSL https://raw.git.corp.tc/infra/buildkite-resources/master/docker-build.sh | bash
