#!/usr/bin/env bash

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
  echo -e -n "\033[0;33m$1: \033[0m"
  read -r
  echo "${REPLY}"
}

# $1 = target
function create_dir() {
  local target="$1"
  if [[ ! -d "${target}" ]]; then
    echo "Creating ${target}"
    mkdir --parents "${target}"
    echo "Created ${target}"
  fi
}

# $1 = target
function change_ownership() {
  local target="$1"
  if [[ ! -O "${target}" ]]; then
    echo "Changing ownership of ${target}"
    sudo chown -R "${USER}:" "${target}"
    echo "Changed ownership of ${target}"
  fi
}

# $1 = target
function create_dir_or_change_ownership() {
  local target="$1"
  create_dir "${target}"
  change_ownership "${target}"
}

# $1 = file
# $2 = content
function create_or_overwrite_file() {
  local file="$1"
  local content="$2"
  if [[ -f "${file}" ]]; then
    change_ownership "${file}"
  fi
  echo "Writing ${file}"
  echo "${content}" > "${file}"
  echo "Wrote ${file}"
}
