## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.2.9 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.35.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.35.2 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_server.github_runner](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [null_resource.deprovision](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.hetzner_machine](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_actions_runner_count"></a> [github\_actions\_runner\_count](#input\_github\_actions\_runner\_count) | Defines the number of runners to be provided. This option is equal to Machines at hetzner. | `number` | `1` | no |
| <a name="input_github_actions_runner_labels"></a> [github\_actions\_runner\_labels](#input\_github\_actions\_runner\_labels) | Defines a list of labels used to identify the runners. The list is divided by separating the individual entries with `,`. | `string` | `""` | no |
| <a name="input_github_actions_runner_replace_existing"></a> [github\_actions\_runner\_replace\_existing](#input\_github\_actions\_runner\_replace\_existing) | Specifies whether to replace existing Github action runners with the same name. | `bool` | `false` | no |
| <a name="input_github_authentication_token"></a> [github\_authentication\_token](#input\_github\_authentication\_token) | Personal access token used to authenticate with Github. The token must have the `admin:org` scope and the necessary permissions to manage runners. | `string` | n/a | yes |
| <a name="input_github_authentication_user"></a> [github\_authentication\_user](#input\_github\_authentication\_user) | Sets the user used for issuing new registration tokens. Ensure that the user has the appropriate permissions. | `string` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | Defines the organisation name or repository owner. | `string` | `""` | no |
| <a name="input_github_repository_name"></a> [github\_repository\_name](#input\_github\_repository\_name) | Sets the name of the repository. This option is only used if you use self-hosted Github runners at the repository level. | `string` | `""` | no |
| <a name="input_github_runner_release"></a> [github\_runner\_release](#input\_github\_runner\_release) | Defines the version of the github runner to be installed. The version must be specified in the format `2.277.1`. | `string` | `"2.298.1"` | no |
| <a name="input_github_runner_type"></a> [github\_runner\_type](#input\_github\_runner\_type) | Defines the github runner type. Available values are: repo, org | `string` | `"repo"` | no |
| <a name="input_hetzner_additional_public_key_ids"></a> [hetzner\_additional\_public\_key\_ids](#input\_hetzner\_additional\_public\_key\_ids) | Adds public keys to the server that are already registered at hetzner | `list(string)` | `[]` | no |
| <a name="input_hetzner_ip_config"></a> [hetzner\_ip\_config](#input\_hetzner\_ip\_config) | Defines the IP configuration for the machine. The IP configuration is used to assign a static IP address to the machine. | <pre>object({<br>    ipv4_enabled = bool<br>    ipv6_enabled = bool<br>  })</pre> | <pre>{<br>  "ipv4_enabled": true,<br>  "ipv6_enabled": true<br>}</pre> | no |
| <a name="input_hetzner_machine_additional_packages"></a> [hetzner\_machine\_additional\_packages](#input\_hetzner\_machine\_additional\_packages) | Defines additional packages that must be installed on the machine. Each package name must be separated by a space ` `. | `string` | `""` | no |
| <a name="input_hetzner_machine_location"></a> [hetzner\_machine\_location](#input\_hetzner\_machine\_location) | Specifies the location of the data center where the machine is to be deployed. | `string` | `"nbg1"` | no |
| <a name="input_hetzner_machine_os"></a> [hetzner\_machine\_os](#input\_hetzner\_machine\_os) | Defines the machine operating system to be installed. | `string` | `"debian-10"` | no |
| <a name="input_hetzner_machine_type"></a> [hetzner\_machine\_type](#input\_hetzner\_machine\_type) | Sets the machine type to use. | `string` | `"cx11"` | no |
| <a name="input_nodejs_version"></a> [nodejs\_version](#input\_nodejs\_version) | Defines the version of nodejs to be installed. | `string` | `"14"` | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | Defines the name for the ssh key | `string` | `"admin_ssh_key"` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Sets the value of the private key. We expect to find the public key in HCLOUD. | `string` | n/a | yes |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username that should be used to connect to the nodes | `string` | `"root"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_runner_ipv4_addresses"></a> [runner\_ipv4\_addresses](#output\_runner\_ipv4\_addresses) | n/a |
| <a name="output_runner_ipv6_addresses"></a> [runner\_ipv6\_addresses](#output\_runner\_ipv6\_addresses) | n/a |
| <a name="output_runner_machine_names"></a> [runner\_machine\_names](#output\_runner\_machine\_names) | n/a |
