#!/bin/bash

set -euo pipefail

export DOCKER_BUILD_OPTIONS="--build-arg LICENSE_KEY=${LICENSE_KEY} --build-arg LICENSE_USERID=${LICENSE_USERID}"

curl -fsSL https://raw.git.corp.tc/infra/buildkite-resources/master/docker-build.sh | bash
