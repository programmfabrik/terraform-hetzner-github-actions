#!/bin/bash

cd /srv/actions-runner

./config.sh --unattended --url $1 --token $2 --name $(hostname) --labels $3 --replace $4 --work _work

sudo ./svc.sh install
sudo ./svc.sh start