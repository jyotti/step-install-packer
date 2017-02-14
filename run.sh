#!/bin/bash
source ./tests/init.sh

PACKER_SYMLINK_DIR="/usr/local/bin"
PACKER_INSTALL_DIR="/usr/local/src"

check_packages() {
  set +e
  local pkgs=""
  command -v curl &> /dev/null || pkgs+=" curl"
  command -v unzip &> /dev/null || pkgs+=" unzip"
  set -e
  if [ ! -z $pkgs ]; then
    apt-get -y update && apt-get -y install $pkgs
  fi
}

main () {
  local version=$1
  local install_dir=$2
  if [ ! -f "${install_dir}/packer_${version}_linux_amd64/packer" ]; then
    check_packages
    info "Fetching Packer..."
    curl -Lo "${install_dir}/packer_${version}_linux_amd64.zip" \
            "https://releases.hashicorp.com/packer/${version}/packer_${version}_linux_amd64.zip"
    info "Installing Packer..."
    unzip -qo "${install_dir}/packer_${version}_linux_amd64.zip" \
              -d "${install_dir}/packer_${version}_linux_amd64"
    rm -f "${install_dir}/packer_${version}_linux_amd64.zip"
  fi
  ln -sf "${install_dir}/packer_${version}_linux_amd64/packer" "${PACKER_SYMLINK_DIR}/packer"
}

# check properties
if [[ ! -n "${WERCKER_INSTALL_PACKER_VERSION}" ]]; then
  fail "Please specify the version property"
fi

if [[ "${WERCKER_INSTALL_PACKER_USE_CACHE}" == "true" ]]; then
  PACKER_INSTALL_DIR="${WERCKER_CACHE_DIR}${PACKER_INSTALL_DIR}"
fi
mkdir -p "${PACKER_SYMLINK_DIR}"
mkdir -p "${PACKER_INSTALL_DIR}"

main "${WERCKER_INSTALL_PACKER_VERSION}" "${PACKER_INSTALL_DIR}"
