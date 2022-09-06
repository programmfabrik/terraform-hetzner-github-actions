# terraform-hetzner-github-actions

This repository provides the functionality to deploy the github actions runner on the hetzner cloud infrastructure. This repository is used to set up the test infrastructure for the fylr application.

## Avaiable variables

| Variable | Type | Default value | Description |
|----------|------|---------------|-------------|
| `hcloud_token` | string | "" | Defines the authentication token with which new machines are registered with the [hetzner cloud](https://www.hetzner.com/cloud). |
| `ssh_private_key` | string | "~/.ssh/id_rsa" | Defines the path to the location of the private key. The private key is used together with the public key to connect to the machine. |
| `ssh_public_key` | string | "~/.ssh/id_rsa.pub" | Defines the path to the location of the public key. The public key is used together with the private key to connect to the machine. |
| `ssh_key_name` | string | `admin_ssh_key` | Defines the name for the ssh key added to the hetzner cloud, as defined in ssh_private_key and ssh_public_key. Must be different from hetzner_additional_public_key_ids. |
| `hetzner_machine_type` | string | "cx11" | Sets the machine type to use. |
| `hetzner_machine_os` | string | "debian-10" | Defines the machine operating system to be installed. |
| `hetzner_additional_public_key_ids` | []string | [] | Adds public keys to the server that are already registered with hetzner |
| `hetzner_machine_additional_packages` | string | "" | Defines additional packages that must be installed on the machine. Each package name must be separated by a space ` `. |
| `hetzner_machine_location` | string | nbg1 | Specifies the location of the data center where the machine is to be deployed. |
| `github_actions_runner_count` | number | 1 | Defines the number of runners to be provided. This option is equal to Machines at hetzner. |
| `github_actions_runner_labels` | string | "" | Defines a list of labels used to identify the runners. The list is divided by separating the individual entries with `,`. |
| `github_actions_runner_replace_existing` | bool | false | Specifies whether to replace existing Github action runners with the same name. |
| `github_owner` | string | "" | Defines the organisation name or repository owner. |
| `github_repository_name` | string | "" | Sets the name of the repository. This option is only used if you use self-hosted Github runners at the repository level. |
| `github_authentication_user` | string | | Sets the user used for issuing new registration tokens. Ensure that the user has the appropriate permissions. |
| `github_authentication_token` | string | | Sets the personal access token for the configured user in the variable github_authentication_user. |
| `github_runner_type` | string | "repo" | Defines the github runner type. Available values are: repo, org |

## Example terraform.tfvars, which provides the runners at repository level

```ini
hcloud_token="<my-hcloud-token>"

hetzner_machine_type="cx21"
hetzner_machine_os="debian-10"
hetzner_additional_public_key_ids=["username@local-system"]
hetzner_machine_additional_packages=""

github_actions_runner_labels="example"
github_actions_runner_replace_existing=false
github_actions_runner_count=3

github_owner="example-repo-owner"
github_repository_name="example-repo-name"
github_authentication_user="example-bot"
github_authentication_token="<example-bot personal access token>"

ssh_key_name="example-bot-ssh-key"
```

## Example terraform.tfvars, which provides the runners at organisation level

```ini
hcloud_token="<my-hcloud-token>"

hetzner_machine_type="cpx21"
hetzner_machine_os="debian-10"
# one of the keys in the hcloud project
hetzner_additional_public_key_ids=["username@local-system"]
# not needed for runner
hetzner_machine_additional_packages=""

# comma separated list
github_actions_runner_labels="example"
github_actions_runner_replace_existing=false
github_actions_runner_count=3

github_owner="programmfabrik"
github_authentication_user="fylr-bot"
github_authentication_token="<example-bot personal access token>"

# not part of hetzner_additional_public_key_ids, see explanation above
ssh_key_name="example-bot-ssh-key"

github_runner_type="org"
```
