#!/usr/bin/env bash
#
# Helper functions for backup scripts
#


err() {
  printf '%b\n' "" > /dev/stderr
  printf '%b\n' "\033[1;31m[ERROR] $@\033[0m" > /dev/stderr
  printf '%b\n' "" > /dev/stderr
  exit 1
}

success() {
  printf '%b\n' ""
  printf '%b\n' "\033[1;32m[SUCCESS] $@\033[0m"
  printf '%b\n' ""
}

lookForImage() {
  local IMAGE_LIST=$(docker images | awk '{print $1}')
  local IMAGE_FOUND="false"

  for image in ${IMAGE_LIST}
  do
    if [ ${image} = ${IMAGE_NAME} ]; then
      IMAGE_FOUND="true"
    fi
  done

  echo ${IMAGE_FOUND}
}

cleaningBusybox() {
  printf '%b\n' ":: Searching for backup container..."
  CONTAINER_SEARCH=$(docker ps -aq --filter="name="${BACKUP_CONTAINER}"")

  if [ ! -z "$CONTAINER_SEARCH" ]; then
    printf '%b\n' " backup container found"
    printf '%b\n' " cleaning container"
    # remove container
    docker rm ${BACKUP_CONTAINER}
  fi
}
