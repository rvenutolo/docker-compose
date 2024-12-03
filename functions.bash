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
function create_dir_or_change_ownership() {
  local target="$1"
  if [[ -d "${target}" ]]; then
    sudo chown -R "${USER}:" "${target}"
  else
    echo "Creating ${target}"
    mkdir --parents "${target}"
    echo "Created ${target}"
  fi
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
