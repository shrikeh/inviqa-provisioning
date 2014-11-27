#!/usr/bin/env bash

# Confirm if a command exists
function command_exists () {
    \command -v ${1} > /dev/null 2>&1 || {
      return 1;
    }
}

function _get_brew() {
  if ! command_exists 'brew'; then
    echo 'Installing brew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    export PATH=/usr/local/bin:/usr/local/sbin:$PATH
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

  mkdir -p "${TARGET_DIR}";

  cd "${TARGET_DIR}";

  _get_brew;

  brew install --force ansible

  rm -rf ./repo

  git clone ${ANSIBLE_REPO} ./repo

  ansible-playbook -i ./repo/ansible/inventory ./repo/ansible/frontend.yml

}

function init() {
  _run_ansible;
}

init
