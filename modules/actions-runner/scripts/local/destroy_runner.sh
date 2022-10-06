#!/bin/bash

machine_names=$1
github_user=$2
github_user_token=$3
github_repo_name=$4
github_owner=$5
github_runner_type=$6

array=(`echo $machine_names | sed 's/,/\n/g'`)
for i in "${array[@]}"
do
    case "$github_runner_type" in
        "repo")
            ./scripts/remote/gh-runner-cli repo runner destroy-by-name \
                --username="$github_user" \
                --token="$github_user_token" \
                --owner="$github_owner" \
                --name="$github_repo_name" \
                --runner-name "$i";;
        "org")
            ./scripts/remote/gh-runner-cli org runner destroy-by-name \
                --username "$github_user" \
                --token "$github_user_token" \
                --name "$github_owner" \
                --runner-name "$i";;
    esac
done
