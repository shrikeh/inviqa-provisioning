#!/usr/bin/env bash




function _get_ansible() {

  local ANSIBLE_DIR="${1}";
  # Kill and recreate the directory to keep it indempotent
  if [ ! -d "${ANSIBLE_DIR}" ]; then
    git clone --recursive http://github.com/ansible/ansible.git "${ANSIBLE_DIR}";
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

  cd "${TARGET_DIR}";

  pip install --upgrade --quiet setuptools;
  pip install --upgrade --quiet pip;
  pip install --upgrade --quiet virtualenv;


  virtualenv "${DEFAULT_VIRTUALENV}";

  ${SOURCE} "./${DEFAULT_VIRTUALENV}/bin/activate";

  export ANSIBLE_LIBRARY="${TARGET_DIR}/library";
  export PYTHONPATH="${TARGET_DIR}/lib:${PYTHON_PATH}";

  CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments pip install ansible

  git clone ${ANSIBLE_REPO} ./repo

  ${TARGET_DIR}/bin/ansible-playbook \
  -i ./repo/ansible/inventory \
   ./repo/ansible/frontend.yml

}

function init() {
  _run_ansible;
}

init
