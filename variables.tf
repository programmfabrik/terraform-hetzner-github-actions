# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
    description = "Hetzner Cloud API token"
    type = string
}

variable "ssh_private_key" {
    description = "Path to the location where the private key is stored to connect to the machines"
    default     = "~/.ssh/id_rsa"
    type = string
}

variable "ssh_public_key" {
    description = "Public Key to authorized the access to the machines"
    default     = "~/.ssh/id_rsa.pub"
    type = string
}

variable "ssh_username" {
    description = "Username that should be used to connect to the nodes"
    default = "root"
    type = string
}

variable "ssh_key_name" {
    description = "Defines the name for the ssh key"
    default = "admin_ssh_key"
    type = string
}

resource "hcloud_ssh_key" "admin_ssh_key" {
    name       = var.ssh_key_name
    public_key = file(var.ssh_public_key)
}

variable "hetzner_machine_type" {
    description = "Defines the hetzner machine"
    default = "cx11"
    type = string
}

variable "hetzner_machine_os" {
    description = "Defines the hetzner machine operation system"
    default = "debian-10"
    type = string
}

variable "github_actions_runner_count" {
    description = "Defines the amount of runners that should be provisioned"
    default = 1
    type = number
}

//

variable "github_actions_runner_labels" {
    description = "Defines a list of labels used to identify the runner. The list is a simple string seperated by ','"
    default = ""
    type = string
}

variable "github_actions_runner_replace_existing" {
    description = "Defines if existing runners should be destroyed"
    default = false
    type = bool
}

variable "github_repository_owner" {
    description = "Defines the repository owner"
    type = string
}

variable "github_repository_name" {
    description = "Defines the repository name"
    type = string
}

variable "github_authentication_user" {
    description = "Defines the authentication username"
    type = string
}

variable "github_authentication_token" {
    description = "Defines the authentication personal access token"
    type = string
}

variable additional_public_key_ids {
    description = "Adds public keys to the server that are already registered at hetzner"
    default = []
    type = list(string)
}