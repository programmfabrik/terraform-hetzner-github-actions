#!/bin/bash

cd /srv/actions-runner

registration_token=$(../gh-runner-cli repo runner provision-token --username=$1 --token=$2 --owner=$3 --name=$4)

./config.sh --unattended --url https://github.com/$3/$4 --token $registration_token --name $(hostname) --labels $5 --replace $6 --work _work

sudo ./svc.sh install
sudo ./svc.sh start
