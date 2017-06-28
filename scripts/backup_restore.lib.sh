#!/usr/bin/env bash
#
# Helper functions for backup scripts
#

source "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/common.lib.sh"


checkRunningBackup() {
  printf '%b\n' ":: Searching for running backup container..."
  CONTAINER_SEARCH=$(docker ps -q --filter="name="${BACKUP_CONTAINER}"")

  if [ ! -z "$CONTAINER_SEARCH" ]; then
    printf '%b\n' " container is found"
    err "backup is already running"
  fi
}


checkRunningRestore() {
  printf '%b\n' ":: Searching for running restore container..."
  CONTAINER_SEARCH=$(docker ps -q --filter="name="${RESTORE_CONTAINER}"")

  if [ ! -z "$CONTAINER_SEARCH" ]; then
    printf '%b\n' " container is found"
    err "restore is already running"
  fi
}
