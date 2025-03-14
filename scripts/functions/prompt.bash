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
# $2 = default value (optional)
function prompt_for_value() {
  if [[ -n "${2:-}" ]]; then
    REPLY=''
    if [[ "${REPLY}" == '' ]]; then
      read -rp $'\e[0;33m'"$1 [$2"$']: \e[0m'
      if [[ "${REPLY}" == '' ]]; then
        REPLY="$2"
      fi
    fi
    echo "${REPLY}"
  else
    REPLY=''
    while [[ -z "${REPLY}" ]]; do
      read -rp $'\e[0;33m'"$1"$': \e[0m'
    done
    echo "${REPLY}"
  fi
}
