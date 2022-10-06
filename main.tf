resource "hcloud_ssh_key" "admin_ssh_key" {
  name       = var.ssh_key_name
  public_key = file(var.ssh_public_key)
}

module "hetzner_gh_runners" {
  source = "./modules/actions-runner"

  ssh_private_key                     = file(var.ssh_private_key)
  ssh_username                        = var.ssh_username
  hetzner_machine_type                = var.hetzner_machine_type
  hetzner_machine_os                  = var.hetzner_machine_os
  hetzner_additional_public_key_ids   = concat([hcloud_ssh_key.admin_ssh_key.id], var.hetzner_additional_public_key_ids)
  hetzner_machine_additional_packages = var.hetzner_machine_additional_packages
  hetzner_machine_location            = var.hetzner_machine_location
  hetzner_ip_config                   = var.hetzner_ip_config

  github_actions_runner_count            = var.github_actions_runner_count
  github_actions_runner_labels           = var.github_actions_runner_labels
  github_actions_runner_replace_existing = var.github_actions_runner_replace_existing
  github_owner                           = var.github_owner
  github_repository_name                 = var.github_repository_name
  github_authentication_user             = var.github_authentication_user
  github_authentication_token            = var.github_authentication_token
  github_runner_type                     = var.github_runner_type
  github_runner_release                  = var.github_runner_release
}
