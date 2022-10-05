# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_private_key" {
  description = "Defines the path to the location of the private key. The private key is used together with the public key to connect to the machine."
  default     = "~/.ssh/id_rsa"
  type        = string
}

variable "ssh_public_key" {
  description = "Public Key to authorized the access to the machines"
  default     = "~/.ssh/id_rsa.pub"
  type        = string
}

variable "ssh_username" {
  description = "Username that should be used to connect to the nodes"
  default     = "root"
  type        = string
}

variable "ssh_key_name" {
  description = "Defines the name for the ssh key"
  default     = "admin_ssh_key"
  type        = string
}

variable "hetzner_machine_type" {
  description = "Sets the machine type to use."
  default     = "cx11"
  type        = string
}

variable "hetzner_machine_os" {
  description = "Defines the machine operating system to be installed."
  default     = "debian-10"
  type        = string
}

variable "hetzner_additional_public_key_ids" {
  description = "Adds public keys to the server that are already registered at hetzner"
  default     = []
  type        = list(string)
}

variable "hetzner_machine_additional_packages" {
  description = "Defines additional packages that must be installed on the machine. Each package name must be separated by a space ` `."
  default     = ""
  type        = string
}

variable "hetzner_machine_location" {
  description = "Specifies the location of the data center where the machine is to be deployed."
  default     = "nbg1"
  type        = string
}

variable "hetzner_ip_config" {
  description = "Defines the IP configuration for the machine. The IP configuration is used to assign a static IP address to the machine."
  default = {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  type = object({
    ipv4_enabled = bool
    ipv6_enabled = bool
  })
}

//

variable "github_actions_runner_count" {
  description = "Defines the number of runners to be provided. This option is equal to Machines at hetzner."
  default     = 1
  type        = number
}

variable "github_actions_runner_labels" {
  description = "Defines a list of labels used to identify the runners. The list is divided by separating the individual entries with `,`."
  default     = ""
  type        = string
}

variable "github_actions_runner_replace_existing" {
  description = "Specifies whether to replace existing Github action runners with the same name."
  default     = false
  type        = bool
}

variable "github_owner" {
  description = "Defines the organisation name or repository owner."
  default     = ""
  type        = string
}

variable "github_repository_name" {
  description = "Sets the name of the repository. This option is only used if you use self-hosted Github runners at the repository level."
  default     = ""
  type        = string
}

variable "github_authentication_user" {
  description = "Sets the user used for issuing new registration tokens. Ensure that the user has the appropriate permissions. "
  type        = string
}

variable "github_authentication_token" {
  description = " Sets the personal access token for the configured user in the variable github_authentication_user."
  type        = string
  sensitive   = true
}

variable "github_runner_type" {
  description = "Defines the github runner type. Available values are: repo, org"
  default     = "repo"
  type        = string
}

variable "github_runner_release" {
  description = "Defines the version of the github runner to be installed. The version must be specified in the format `2.277.1`."
  default     = "2.298.1"
  type        = string
}
