#!/usr/bin/env bash

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
