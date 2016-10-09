#!/usr/bin/env bash
#
# (c) 2016 TRITON (Jared Allard <jaredallard@tritonjs.com>)
# License: MIT
#
# Escalate a user to admin by modifying the DB.
#
# Error Codes
# - 1 Normal Error
# - 2 Node isn't installed.
# - 3 API Error

node -v > /dev/null || echo "Error: Node is required to run this. $(exit 1)"

help() {
  echo "admin DB_HOST APIKEY"
}

if [[ -z $1 ]] || [[ -z $2 ]]; then
  help
  exit 1
fi
SCRIPT_CWD=`dirname "$0"`
DB=$1
APIKEY=$2

DB_PORT=${DB} node ${SCRIPT_CWD}/lib/escalate.js ${APIKEY}
