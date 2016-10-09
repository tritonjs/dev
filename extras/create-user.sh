#!/usr/bin/env bash
#
# (c) 2016 TRITON (Jared Allard <jaredallard@tritonjs.com>)
# License: MIT
#
# Create a User.
#
# create-user USERNAME PASSWORD EMAIL
#
# Error Codes
# - 1 Normal Error
# - 2 Node isn't installed.
# - 3 API Error

node -v > /dev/null || echo "Error: Node is required to run this. $(exit 1)"

help() {
  echo "create-user USERNAME PASSWORD EMAIL DISPLAY_NAME"
}

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $4 ]]; then
  help
  exit 1
fi

SCRIPT_CWD=`dirname "$0"`
PATH=$PATH:${SCRIPT_CWD}

HOST="http://127.0.0.1:8080"
ENDPOINT="/v1/users/new"
USERNAME=$1
PASSWORD=$2
EMAIL=$3
DISPLAY_NAME=$4

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
   \"password\": \"${PASSWORD}\",        \
   \"email\": \"${EMAIL}\",              \
   \"display_name\": \"${DISPLAY_NAME}\" \
}" ${HOST}${ENDPOINT} 2>/dev/null)
RESULT_SUCCESS=$(parse_json success ${RESULT})

if [ ${RESULT_SUCCESS} == "false" ]; then
  echo "Error: $(parse_json message ${RESULT})"
  exit 3
fi

echo "Created User: '${USERNAME}'"
