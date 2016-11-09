#!/bin/bash

#set -x

error_exit() {
    local message=$1

    echo "[FATAL] $message" 1>&2
    exit 1
}

install_deps() {
  local deps="0"
  type unzip &> /dev/null || deps="1"
  type wget &> /dev/null  || deps="1"
  if [ ${deps} -eq "1" ]; then
    echo "Install packages..."
    apt-get update && apt-get install -y wget unzip
  fi
}

download_packer() {
  local install_path=$1
  local version=$2

  set +e
  install_deps
  set -e

  if [ ! -f "${install_path}/packer_${version}_linux_amd64/packer" ]; then
    echo "Install packer ..."
    wget -qO ${install_path}/packer_${version}_linux_amd64.zip https://releases.hashicorp.com/packer/${version}/packer_${version}_linux_amd64.zip
    unzip -qo "${install_path}/packer_${version}_linux_amd64.zip" -d "${install_path}/packer_${version}_linux_amd64"
    rm -f ${install_path}/packer_${version}_linux_amd64.zip
  fi
  ln -sf ${install_path}/packer_${version}_linux_amd64/packer ${install_path}/bin/packer
  return 0
}

# check properties
if [ ! -n "${WERCKER_INSTALL_PACKER_VERSION}" ]; then
  error_exit 'Please specify the version property'
fi

# default
# ${HOME}/github/jyotti/bin/packer
# ${HOME}/github/jyotti/packer_x.x.x/packer
#
# cache
# ${WERCKER_CACHE_DIR}/github/jyotti/bin/packer
# ${WERCKER_CACHE_DIR}/github/jyotti/packer_x.x.x/packer
INSTALL_PATH=""
if [ -n "${WERCKER_INSTALL_PACKER_USE_CACHE}" -a "${WERCKER_INSTALL_PACKER_USE_CACHE}" == "true" ]; then
  INSTALL_PATH=${WERCKER_CACHE_DIR}/github/jyotti
else
  INSTALL_PATH=${HOME}/github/jyotti
fi
mkdir -p ${INSTALL_PATH}/bin
PATH=${PATH}:${INSTALL_PATH}/bin
download_packer ${INSTALL_PATH} ${WERCKER_INSTALL_PACKER_VERSION}
