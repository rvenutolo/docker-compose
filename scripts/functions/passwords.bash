#!/usr/bin/env bash

# $1 = length
function generate_password() {
  pwgen --secure --capitalize --numerals --symbols --remove-chars '$\\:;=`"'\' --num-passwords 1 "${1:-32}"
}
