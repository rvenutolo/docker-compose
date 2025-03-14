#!/usr/bin/env bash

# $1 = dir
function dir_exists() {
  [[ -d "$1" ]]
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
