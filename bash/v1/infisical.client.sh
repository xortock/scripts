#!/bin/sh

infisical_install_and_configure() {
  curl -1sLf \
    'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh' |
    bash

  apt-get update

  if [ -z $1]; then 
    apt-get install infisical
  else 
    apt-get install infisical=$1
  fi

  export INFISICAL_DISABLE_UPDATE_CHECK=true

  if [ -z "$INFISICAL_CLIENT_ID" ] || [ -z "$INFISICAL_CLIENT_SECRET" ]; then
    echo "Error: INFISICAL_CLIENT_ID and INFISICAL_CLIENT_SECRET must be set."
    exit 1
  fi

  export INFISICAL_TOKEN=$(infisical login --method=universal-auth --client-id=$INFISICAL_CLIENT_ID --client-secret=$INFISICAL_CLIENT_SECRET --silent --plain)
}

infisical_apk_install_and_configure() {
  curl -1sLf \
    'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.alpine.sh' |
    bash

  apk update

  if [ -z $1]; then 
    apk add infisical
  else 
    apk add infisical=$1
  fi

  export INFISICAL_DISABLE_UPDATE_CHECK=true

  if [ -z "$INFISICAL_CLIENT_ID" ] || [ -z "$INFISICAL_CLIENT_SECRET" ]; then
    echo "Error: INFISICAL_CLIENT_ID and INFISICAL_CLIENT_SECRET must be set."
    exit 1
  fi

  export INFISICAL_TOKEN=$(infisical login --method=universal-auth --client-id=$INFISICAL_CLIENT_ID --client-secret=$INFISICAL_CLIENT_SECRET --silent --plain)
}

infisical_npm_install_and_configure() {
  npm install -g @infisical/cli

  export INFISICAL_DISABLE_UPDATE_CHECK=true

  if [ -z "$INFISICAL_CLIENT_ID" ] || [ -z "$INFISICAL_CLIENT_SECRET" ]; then
    echo "Error: INFISICAL_CLIENT_ID and INFISICAL_CLIENT_SECRET must be set."
    exit 1
  fi

  export INFISICAL_TOKEN=$(infisical login --method=universal-auth --client-id=$INFISICAL_CLIENT_ID --client-secret=$INFISICAL_CLIENT_SECRET --silent --plain)
}


infisical_create_secret_if_not_exists() {
  local secret_name=$1
  local secret_value=$2
  local project_id=$3

  local existing_secret=$(infisical secrets --projectId=$project_id get $secret_name --plain)

  if [ -z $existing_secret ]; then
    infisical secrets --projectId=$project_id set $secret_name=$secret_value
    echo $secret_value
  else
    echo $existing_secret
  fi
}

infisical_get_secret() {
  local secret_name=$1
  local project_id=$2

  infisical secrets --projectId=$project_id get $secret_name --plain
}