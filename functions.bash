#!/usr/bin/env bash

function log() {
  echo -e "\033[0;32m[$(date +%T) ${0##*/}] $*\033[0m" >&2
}

function die() {
  echo -e "\033[0;31mDIE: $* (at ${BASH_SOURCE[1]}:${FUNCNAME[1]} line ${BASH_LINENO[0]})\033[0m" >&2
  exit 1
}

# $1 = question
function prompt_ny() {
  REPLY=''
  while [[ "${REPLY}" != 'y' && "${REPLY}" != 'n' ]]; do
    echo -e -n "\033[0;33m$1 [y/N]: \033[0m"
    read -r
    if [[ "${REPLY}" == [yY] ]]; then
      REPLY='y'
    elif [[ "${REPLY}" == '' || "${REPLY}" == [nN] ]]; then
      REPLY='n'
    fi
  done
  [[ "${REPLY}" == 'y' ]]
}

# $1 = question
function prompt_yn() {
  REPLY=''
  while [[ "${REPLY}" != 'y' && "${REPLY}" != 'n' ]]; do
    echo -e -n "\033[0;33m$1 [Y/n]: \033[0m"
    read -r
    if [[ "${REPLY}" == '' || "${REPLY}" == [yY] ]]; then
      REPLY='y'
    elif [[ "${REPLY}" == [nN] ]]; then
      REPLY='n'
    fi
  done
  [[ "${REPLY}" == 'y' ]]
}

# $1 = question
function prompt_for_value() {
  REPLY=''
  read -rp "$1 : "
  echo "${REPLY}"
}

# $@ = targets
function create_dir() {
  for target in "$@"; do
    if [[ ! -d "${target}" ]]; then
      log "Creating ${target}"
      mkdir --parents "${target}"
      log "Created ${target}"
    fi
  done
}

# $1 = file
# $2 = content
function write_file() {
  log "Writing $1"
  echo "${2:-}" > "$1"
  log "Wrote $1"
}

# $1 = file
# $2 = content
function write_file_if_not_exists() {
  if [[ ! -f "${1}" ]]; then
    write_file "$1" "${2:-}"
  fi
}

# $1 = file
# $2 = content
function root_write_file() {
  log "Writing $1"
  echo "$2" | sudo tee "$1" > '/dev/null'
  log "Wrote $1"
}

function this_script_dir() {
  cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &> '/dev/null' && pwd
}

function env_file() {
  echo "$(cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &> '/dev/null' && pwd)/.env"
}

# $1 = file
function check_for_file() {
  if ! [[ -f "$1" ]]; then
    die "$1 does not exist"
  fi
}

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
