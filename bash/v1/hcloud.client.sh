#!/bin/bash

hcloud:install_cli() {
    curl -sSLO https://github.com/hetznercloud/cli/releases/latest/download/hcloud-linux-amd64.tar.gz
    sudo tar -C /usr/local/bin --no-same-owner -xzf hcloud-linux-amd64.tar.gz hcloud
    rm hcloud-linux-amd64.tar.gz
}