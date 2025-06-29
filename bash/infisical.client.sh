#!/bin/bash

create_secret_if_not_exists() {
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