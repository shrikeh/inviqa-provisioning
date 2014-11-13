#!/usr/bin/env bash




function _get_pip() {
  curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo python2.7
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

  _get_pip

  pip install --upgrade --quiet setuptools;
  pip install --upgrade --quiet pip;
  pip install --upgrade --quiet virtualenv;


  virtualenv "${DEFAULT_VIRTUALENV}";

  ${SOURCE} "./${DEFAULT_VIRTUALENV}/bin/activate";

  export ANSIBLE_LIBRARY="${TARGET_DIR}/library";
  export PYTHONPATH="${TARGET_DIR}/lib:${PYTHON_PATH}";

  CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments pip install ansible

  rm -rf ./repo

  git clone ${ANSIBLE_REPO} ./repo

  ansible-playbook -i ./repo/ansible/inventory ./repo/ansible/frontend.yml

}

function init() {
  _run_ansible;
}

init
