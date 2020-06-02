#!/bin/bash

set -euo pipefail

curl -fsSL https://raw.git.corp.tc/infra/buildkite-resources/master/docker-build.sh | bash
