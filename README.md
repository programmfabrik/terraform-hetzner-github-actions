# terraform-hetzner-github-actions

This repository provides the functionality to deploy the github actions runner on the hetzner cloud infrastructure.

## Avaiable variables

| Variable | Type | Default value | Description |
|----------|------|---------------|-------------|
| `hcloud_token` | string | "" | Defines the authentication token with which new machines are registered with the [hetzner cloud](https://www.hetzner.com/cloud). |
| `hetzner_machine_type` | string | "cx11" | Define the machine type to be used. |
| `hetzner_machine_os` | string | "debian-10" | Defines the machine operating system to be installed. |
| `github_actions_provision_url` | string | "" | Specifies the location to use for registering new devices. Can be a repository or a company. Example: `https://github.com/programmfabrik/terraform-hetzner-github-actions`. |
| `github_actions_provision_token` | string | "" | Defines the authentication token used to register new Github action runners. |
| `github_actions_runner_replace_existing` | bool | false | Specifies whether to replace existing Github action runners with the same name. |
| `github_actions_runner_labels` | string | "" | Defines a list of labels used to identify the runners. The list is divided by separating the individual entries with `,`. |
