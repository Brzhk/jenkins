#!/usr/bin/env bash
#
# Build Docker image
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

found=$(lookForImage)
if [ ${found} = "true" ]; then
  err ""${IMAGE_NAME}" does exist, cannot build"
fi

printf '%b\n' ""
printf '%b\n' ":: Building image..."

docker build -t ${IMAGE_NAME} .

found=$(lookForImage)
if [ ${found} = "false" ]; then
  err ""${IMAGE_NAME}" not found, build failed"
fi

success "Image build successfully."

