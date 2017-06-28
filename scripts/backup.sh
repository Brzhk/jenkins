#!/usr/bin/env bash
#
# Backup docker volume ["/jenkins"] from docker container.
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
source ${CUR_DIR}/backup_restore.lib.sh


#------------------
# SCRIPT ENTRYPOINT
#------------------

printf '%b\n' ":: Searching for "${CONTAINER_NAME}" docker container..."
CONTAINER_ID=$(docker ps -aq --filter="name="${CONTAINER_NAME}"")

if [ -z "$CONTAINER_ID" ]; then
  err ""${CONTAINER_NAME}" container not found"
fi

printf '%b\n' " container found"
printf '%b\n' ""
printf '%b\n' ":: backing up "${CONTAINER_VOLUME}" folder from container..."

# make sure backups directory exists
if [ ! -d "${BACKUP_DIR}" ]; then
  err ""${BACKUP_DIR}" not found"
fi

checkRunningBackup

cleaningBusybox

printf '%b\n' ":: Starting backup..."

backup_filename=${BACKUP_FILE_PREFIX}-$(date +${FILE_TIMESTAMP}).tar
$(docker run --name=""${BACKUP_CONTAINER}"" --rm --volumes-from ${CONTAINER_NAME} -v ${BACKUP_DIR}:/backup busybox tar cf /backup/${backup_filename} ${CONTAINER_VOLUME})
if [[ "$?" -ne 0 ]]; then
  err "Backup failed"
fi

cleaningBusybox

printf '%b\n' " backup directory: ${BACKUP_DIR}"
printf '%b\n' " backup file     : ${backup_filename}"

success "Backup complete"

