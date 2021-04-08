#!/bin/bash

machine_names=$1
github_user=$2
github_user_token=$3
github_repo_name=$4
github_repo_owner=$5

array=(`echo $machine_names | sed 's/,/\n/g'`)
for i in "${array[@]}"
do
    ./scripts/remote/gh-runner-cli repo runner destroy-by-name --username="$github_user" --token="$github_user_token" --owner="$github_repo_owner" --name="$github_repo_name" --runner-name "$i"
done

#runner_id=$(../gh-runner-cli repo runner id-by-name --username=$1 --token=$2 --owner=$3 --name=$4 --runner-name=$5)

#../gh-runner-cli repo runner destroy --username=$1 --token=$2 --owner=$3 --name=$4