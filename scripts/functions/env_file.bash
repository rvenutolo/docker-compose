#!/usr/bin/env bash

# $1 = env file
# $2 = var
function get_env_file_var() {
  check_for_file "$1"
  if ! grep --quiet "^$2=" "$1"; then
    die "$2 does not exist in $1"
  fi
  grep "^$2=" "$1" | cut --delimiter='=' --fields='2'
}

# $1 = env file
# $2 = var
function env_file_var_defined() {
  local var_value
  var_value="$(get_env_file_var "$1" "$2")" || exit 1
  [[ -n "${var_value}" ]]
}

# $1 = env file
# $2 = var
function get_env_file_defined_var() {
  if ! env_file_var_defined "$1" "$2"; then
    die "$2 is not defined in $1"
  fi
  get_env_file_var "$1" "$2"
}

# $1 = var
function get_var() {
  if [[ -z "${env_file:-}" ]]; then
    die "env_file is not defined"
  fi
  get_env_file_defined_var "${env_file}" "$1"
}

# $1 = env file
# $2 = var
# $3 = info (optional)
function set_env_file_var() {
  check_for_file "$1"
  local var_value
  if [[ -n "$3" ]]; then
    var_value="$(prompt_for_value "Enter value for $2 ($3)")" || exit 1
  else
    var_value="$(prompt_for_value "Enter value for $2")" || exit 1
  fi
  sed --in-place "s|^$2=.*$|$2=${var_value}|" "$1"
}

# $1 = env file
# $2 = var
# $3 = info (optional)
function set_env_file_var_if_not_defined() {
  if ! env_file_var_defined "$1" "$2"; then
    set_env_file_var "$1" "$2" "${3:-}"
  fi
}

## TODO do something to rename the set_var function
## TODO function to set pw var with default suggestion

# $1 = var
# $2 = info (optional)
function set_var() {
  if [[ -z "${env_file:-}" ]]; then
    die "env_file is not defined"
  fi
  set_env_file_var_if_not_defined "${env_file}" "$1" "${2:-}"
}

# $1 = env file
# $2 = var
# $3 = value
function set_env_file_var_to_value() {
  sed --in-place "s|^$2=.*$|$2=$3|" "$1"
}
