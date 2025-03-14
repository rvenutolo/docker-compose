#!/usr/bin/env bash

function this_script_dir() {
  cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &> '/dev/null' && pwd
}

function env_file() {
  echo "$(cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &> '/dev/null' && pwd)/.env"
}
