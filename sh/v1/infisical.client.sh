#!/bin/sh

infisical:hello() {
  echo "Hello from Infisical client script!"
}

infisical:install_and_configure() {
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

infisical:create_secret_if_not_exists() {
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
