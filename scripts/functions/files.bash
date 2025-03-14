#!/usr/bin/env bash

# $1 = file
function file_exists() {
  [[ -f "$1" ]]
}

# $1 = file
function check_for_file() {
  if ! [[ -f "$1" ]]; then
    die "$1 does not exist"
  fi
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
