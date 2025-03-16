#!/usr/bin/env bash

source "${SCRIPTS_DIR}/functions.bash"

export ENV_FILE="$(cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &> '/dev/null' && pwd)/.env"

# $1 = var
function get_var() {
  check_exactly_1_arg "$@"
  if [[ -z "${ENV_FILE:-}" ]]; then
    die 'ENV_FILE is not defined'
  fi
  get_env_file_defined_var_value "${ENV_FILE}" "$1"
}

# $1 = var
# $2 = info (optional)
function set_var() {
  check_at_least_1_arg "$@"
  check_at_most_2_args "$@"
  if [[ -z "${ENV_FILE:-}" ]]; then
    die 'ENV_FILE is not defined'
  fi
  prompt_and_define_env_file_var_value "${ENV_FILE}" "$1" "${2:-}"
}

# $1 = var
# $2 = default
function set_var_with_default() {
  check_exactly_2_args "$@"
  if [[ -z "${ENV_FILE:-}" ]]; then
    die 'ENV_FILE is not defined'
  fi
  prompt_and_define_env_file_var_value_with_default "${ENV_FILE}" "$1" "$2"
}

function copy_env_file_template() {
  check_no_args "$@"
  if [[ -z "${ENV_FILE:-}" ]]; then
    die 'ENV_FILE is not defined'
  fi
  assert_file_exists "${ENV_FILE}.template"
  if ! file_exists "${ENV_FILE}"; then
    cp "${ENV_FILE}.template" "${ENV_FILE}"
  fi
}
