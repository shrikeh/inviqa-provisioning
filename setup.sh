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

  local SOURCE='source'

  local ANSIBLE_WORKDIR="${1:-${TMPDIR=}}";

  declare -r DEFAULT_TARGET_DIR="${ANSIBLE_WORKDIR}/${DEFAULT_ANSIBLE_DIR}";

  local TARGET_DIR="${2:-${DEFAULT_TARGET_DIR}}";

  _get_ansible ${TARGET_DIR}

  cd "${TARGET_DIR}";

  pip install --upgrade --quiet setuptools;
  pip install --upgrade --quiet pip;
  pip install --upgrade --quiet virtualenv;


  virtualenv "${DEFAULT_VIRTUALENV}";

  ${SOURCE} "./${DEFAULT_VIRTUALENV}/bin/activate";

  export ANSIBLE_LIBRARY="${TARGET_DIR}/library";
  export PYTHONPATH="${TARGET_DIR}/lib:${PYTHON_PATH}";

  pip install --upgrade --quiet PyYAML jinja2;

  ${TARGET_DIR}/bin/ansible-playbook \
  -i ~/Workspace/work/inviqa/inviqa-provisioning/ansible/inventory \
   ~/Workspace/work/inviqa/inviqa-provisioning/ansible/frontend.yml

}

function init() {
  _run_ansible;
}

init
