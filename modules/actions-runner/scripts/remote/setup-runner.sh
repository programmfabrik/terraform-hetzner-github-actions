#!/bin/bash

cd /srv/actions-runner

case "$GH_RUNNER_TYPE" in
    "repo")
        registration_token=$(../gh-runner-cli repo runner provision-token --username=$GH_USERNAME --token=$GH_TOKEN --owner=$GH_OWNER --name=$GH_NAME)
        ./config.sh \
            --unattended \
            --url https://github.com/$GH_OWNER/$GH_NAME \
            --token $registration_token \
            --name $CUSTOM_HOSTNAME \
            --labels $GH_LABELS \
            --replace $GH_REPLACE_RUNNERS \
            --work _work;;
    "org")
        registration_token=$(../gh-runner-cli org runner provision-token --username=$GH_USERNAME --token=$GH_TOKEN --name=$GH_OWNER)
        ./config.sh \
            --unattended \
            --url https://github.com/$GH_OWNER \
            --token $registration_token \
            --name $CUSTOM_HOSTNAME \
            --labels $GH_LABELS \
            --replace $GH_REPLACE_RUNNERS \
            --work _work;;
esac

sudo ./svc.sh install
sudo ./svc.sh start
