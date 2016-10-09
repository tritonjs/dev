#!/usr/bin/env bash
#
# (c) 2016 TRITON (Jared Allard <jaredallard@tritonjs.com>)
# License: MIT
#
# Get User API Key.
#
# Error Codes
# - 1 Normal Error
# - 2 Node isn't installed.
# - 3 API Error

node -v > /dev/null || echo "Error: Node is required to run this. $(exit 1)"

help() {
  echo "login USERNAME PASSWORD [PLAIN]"

}

if [[ -z $1 ]] || [[ -z $2 ]]; then
  help
  exit 1
fi

SCRIPT_CWD=`dirname "$0"`
PATH=$PATH:${SCRIPT_CWD}

HOST="http://127.0.0.1:8080"
ENDPOINT="/v1/users/authflow"
USERNAME=$1
PASSWORD=$2
PLAIN=$3

# Load JSON Module
. ${SCRIPT_CWD}/lib/json.sh

# Check that API is *sane*.
API_PING=$(curl $HOST 2>/dev/null) || echo "Error: Failed to determine API sanity. (offline?)"
API_PING_SUCCESS=$(parse_json success ${API_PING})

if [[ ! ${API_PING_SUCCESS} ]]; then
  echo "Error: API success false on base."
  exit 3
fi

RESULT=$(curl -X POST -H "Content-Type: application/json" -d \
"{ \
   \"username\": \"${USERNAME}\",        \
   \"password\": \"${PASSWORD}\"         \
}" ${HOST}${ENDPOINT} 2>/dev/null)
RESULT_SUCCESS=$(parse_json success ${RESULT})

if [ "${RESULT_SUCCESS}" == "false" ]; then
  echo "Error: $(parse_json message ${RESULT})"
  exit 3
fi

API_SECRET=$(parse_json data.secret ${RESULT})
API_PUBLIC=$(parse_json data.public ${RESULT})

if [ "${PLAIN}" == "true" ]; then
  echo ${API_PUBLIC}:${API_SECRET}
  exit
fi

echo "APIKEY for '${USERNAME}': ${API_PUBLIC}:${API_SECRET}"
