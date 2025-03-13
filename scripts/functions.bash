#!/usr/bin/env bash

function log() {
  echo -e "\033[0;32m[$(date '+%T') ${0##*/}] $*\033[0m" >&2
}

function log_with_date() {
  echo -e "\033[0;32m[$(date '+%Y-%m-%d %T') ${0##*/}] $*\033[0m" >&2
}

function die() {
  echo -e "\033[0;31mDIE: $* (at ${BASH_SOURCE[1]}:${FUNCNAME[1]} line ${BASH_LINENO[0]})\033[0m" >&2
  exit 1
}

# $1 = start seconds
# $2 = end seconds
function calc_elapsed() {
  local elapsed=$(($2 - $1))
  local hrs=$((elapsed / 3600))
  local mins=$(((elapsed - hrs * 3600) / 60))
  local secs=$((elapsed - hrs * 3600 - mins * 60))
  if [[ ${hrs} -gt 0 ]]; then
    echo -n "${hrs}h "
  fi
  if [[ ${mins} -gt 0 ]]; then
    echo -n "${mins}m "
  fi
  echo "${secs}s"
}

function shell_elapsed_time() {
  calc_elapsed 0 $SECONDS
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

# $@ = targets
function root_create_dir() {
  for target in "$@"; do
    if [[ ! -d "${target}" ]]; then
      log "Creating ${target}"
      sudo mkdir --parents "${target}"
      log "Created ${target}"
    fi
  done
}

# $1 = old file location
# $2 = new file location
function copy_file() {
  if [[ ! -f "$1" ]]; then
    die "$1 does not exist"
  fi
  if [[ "$1" == "$2" ]]; then
    die "File paths are the same"
  fi
  if [[ ! -f "$2" ]] || ! cmp --silent "$1" "$2"; then
    log "Copying: $1 -> $2"
    mkdir --parents "$(dirname "$2")"
    cp "$1" "$2"
    log "Copied: $1 -> $2"
  fi
}

# $1 = source file
# $2 = destination file
function root_copy_file() {
  if [[ ! -f "$1" ]]; then
    die "$1 does not exist"
  fi
  if [[ "$1" == "$2" ]]; then
    die "File paths are the same"
  fi
  if [[ ! -f "$2" ]] || ! cmp --silent "$1" "$2"; then
    log "Copying: $1 -> $2"
    sudo mkdir --parents "$(dirname "$2")"
    sudo cp "$1" "$2"
    log "Copied: $1 -> $2"
  fi
}

# $1 = file
# $2 = content
function write_file() {
  log "Writing $1"
  if [[ ! -d "$(dirname "$1")" ]]; then
    mkdir --parents "$(dirname "$1")"
  fi
  echo "${2:-}" > "$1"
  log "Wrote $1"
}

# $1 = file
# $2 = content
function root_write_file() {
  log "Writing $1"
  if [[ ! -d "$(dirname "$1")" ]]; then
    sudo mkdir --parents "$(dirname "$1")"
  fi
  echo "$2" | sudo tee "$1" > '/dev/null'
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
function root_write_file_if_not_exists() {
  if [[ ! -f "${1}" ]]; then
    root_write_file "$1" "${2:-}"
  fi
}

# $1 = file
# $2 = content
function write_app_data_file_if_not_exists() {
  if [[ ! -f "${DOCKER_APP_DATA_DIR}/$1" ]]; then
    root_write_file "${DOCKER_APP_DATA_DIR}/$1" "${2:-}"
  fi
}

function this_script_dir() {
  cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &> '/dev/null' && pwd
}

function env_file() {
  echo "$(cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &> '/dev/null' && pwd)/.env"
}

# $1 = file
function file_exists() {
  [[ -f "$1" ]]
}

# $1 = dir
function dir_exists() {
  [[ -d "$1" ]]
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

# $1 = container name
function container_is_running() {
  [[ -n "$(docker ps --quiet --filter "name=^$1\$")" ]] && [[ "$(docker container inspect -f '{{.State.Status}}' "$1")" == 'running' ]]
}

# $1 = service unit file
function user_service_unit_file_exists() {
  systemctl --user list-unit-files --all --quiet "$1" > '/dev/null'
}

# $1 = service unit file
function enable_user_service_unit() {
  if user_service_unit_file_exists "$1"; then
    if ! systemctl is-enabled --user --quiet "$1" && prompt_yn "Enable and start $1 user service?"; then
      log "Enabling and starting $1 user service"
      systemctl enable --now --user --quiet "$1"
      log "Enabled and started $1 user service"
    fi
  else
    log "User service unit files does not exist: $1"
  fi
}
