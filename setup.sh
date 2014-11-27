#!/usr/bin/env bash

# Confirm if a command exists
function command_exists () {
    \command -v ${1} > /dev/null 2>&1 || {
      return 1;
    }
}


function _get_pip() {
  if ! command_exists 'pip'; then
    echo 'Pip not found: installing, you will be prompted for sudo'
    sudo easy_install --user pip
  fi
}

function _run_ansible() {

  declare -r DEFAULT_ANSIBLE_DIR='ansible';
  declare -r DEFAULT_VIRTUALENV='venv'
  declare -r DEFAULT_ANSIBLE_REPO='https://github.com/shrikeh/inviqa-provisioning'

  local SOURCE='source'
  local ANSIBLE_WORKDIR="${1:-${TMPDIR}}";
  local ANSIBLE_REPO="${2:-${DEFAULT_ANSIBLE_REPO}}";

  declare -r DEFAULT_TARGET_DIR="${ANSIBLE_WORKDIR}/${DEFAULT_ANSIBLE_DIR}";

  local TARGET_DIR="${3:-${DEFAULT_TARGET_DIR}}";

  mkdir -p "${TARGET_DIR}"

  cd "${TARGET_DIR}";

  local PIP_SUDO='sudo'

  _get_pip

  declare -r PIP_PATH="${HOME}/Library/Python2.7/bin/pip"

  local PIP_INSTALL="${PIP_SUDO} ${PIP_PATH} install --upgrade --quiet";

  "${PIP_INSTALL} setuptools";
  "${PIP_INSTALL} pip";
  "${PIP_INSTALL} virtualenv";

  virtualenv "${DEFAULT_VIRTUALENV}";

  ${SOURCE} "./${DEFAULT_VIRTUALENV}/bin/activate";

  "${PIP_INSTALL} ansible";

  rm -rf ./repo

  git clone ${ANSIBLE_REPO} ./repo

  ansible-playbook -i ./repo/ansible/inventory ./repo/ansible/frontend.yml

}

function init() {
  _run_ansible;
}

init
