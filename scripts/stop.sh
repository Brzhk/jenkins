#!/usr/bin/env bash
#
# Stop Docker container
#

set -o errexit    # abort script at first error
set -o pipefail   # return the exit status of the last command in the pipe
set -o nounset    # treat unset variables and parameters as an error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading container config...."
source ${CUR_DIR}/container.cfg

printf '%b\n' ":: Reading scripts config...."
source ${CUR_DIR}/scripts.cfg

printf '%b\n' ":: importing helper functions...."
source ${CUR_DIR}/common.lib.sh


#------------------
# SCRIPT ENTRYPOINT
#------------------

printf '%b\n' ":: Searching for "${CONTAINER_NAME}" container..."
CONTAINER_ID=$(docker ps -q --filter="name="${CONTAINER_NAME}"")

if [ -z "$CONTAINER_ID" ]; then
  err ""${CONTAINER_NAME}" not running"
fi

printf '%b\n' ""
printf '%b\n' ":: Stop container..."

stop=$(docker stop ${CONTAINER_NAME})
if [[ "$?" -ne 0 ]]; then
  err "Could not stop "${CONTAINER_NAME}" container"
fi

printf '%b\n' ":: Searching for "${CONTAINER_NAME}" docker container..."
CONTAINER_ID=$(docker ps -q --filter="name="${CONTAINER_NAME}"")

if [ ! -z "$CONTAINER_ID" ]; then
  err ""${CONTAINER_NAME}" still running"
fi

success "Container stopped successful."