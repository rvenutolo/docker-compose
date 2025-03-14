#!/usr/bin/env bash

# shellcheck disable=SC1090
for file in "${DOCKER_DIR}"/scripts/functions/*.bash; do
  source "${file}"
done
