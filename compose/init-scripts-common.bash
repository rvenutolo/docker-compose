#!/usr/bin/env bash

source "${SCRIPTS_DIR}/functions.bash"

ENV_FILE="$(cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &> '/dev/null' && pwd)/.env"

function copy_env_file_template() {
  check_no_args "$@"
  assert_var_set 'ENV_FILE'
  assert_file_exists "${ENV_FILE}.template"
  if ! file_exists "${ENV_FILE}"; then
    cp "${ENV_FILE}.template" "${ENV_FILE}"
  fi
}

# $1 = var
function env_file_val() {
  check_exactly_1_arg "$@"
  assert_var_set 'ENV_FILE'
  get_env_file_var_value "${ENV_FILE}" "$1"
}

# $1 = var
# $2 = value
function set_env_file_val() {
  check_exactly_2_args "$@"
  assert_var_set 'ENV_FILE'
  set_env_file_var_value "${ENV_FILE}" "$1" "$2"
}

# $1 = var
# $2 = var info (optional)
function prompt_set_env_file_val() {
  check_at_least_1_arg "$@"
  check_at_most_2_args "$@"
  assert_var_set 'ENV_FILE'
  prompt_env_file_var_value_if_empty "${ENV_FILE}" "$1" "${2:-}"
}

# $1 = var
# $2 = var info (optional)
function prompt_set_env_file_password_val() {
  check_at_least_1_arg "$@"
  check_at_most_2_args "$@"
  assert_var_set 'ENV_FILE'
  prompt_env_file_pw_value_if_empty "${ENV_FILE}" "$1" "${2:-}"
}

# $1 = app data file
# $2 = content
function write_app_data_file_if_not_exists() {
  local target_file="${DOCKER_APP_DATA_DIR}/$1"
  if ! file_exists "${target_file}"; then
    write_file "${target_file}" "$2"
  fi
}

function root_write_app_data_file_if_not_exists() {
  local target_file="${DOCKER_APP_DATA_DIR}/$1"
  if ! file_exists "${target_file}"; then
    root_write_file "${target_file}" "$2"
  fi
}
