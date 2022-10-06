locals {
  fill_char_length = 64 - length("github-runner") - 4

  default_package_list = join(" ", [
    "sudo",
    "git",
    "vim",
    "tmux",
    "apt-transport-https",
    "ca-certificates",
    "curl",
    "gnupg",
    "lsb-release",
    "pass",
    "jq",
    "make",
    "unzip",
    "wget",
  ])

}

resource "random_string" "hetzner_machine" {
  length  = local.fill_char_length > 0 ? local.fill_char_length : 0
  special = false
}

resource "hcloud_server" "github_runner" {
  count       = var.github_actions_runner_count
  name        = format("%s-%s-%d", "github-runner", random_string.hetzner_machine.result, count.index + 1)
  server_type = var.hetzner_machine_type
  image       = var.hetzner_machine_os
  location    = var.hetzner_machine_location
  ssh_keys    = var.hetzner_additional_public_key_ids
  public_net {
    ipv4_enabled = var.hetzner_ip_config.ipv4_enabled == false && var.hetzner_ip_config.ipv6_enabled == false ? true : var.hetzner_ip_config.ipv4_enabled
    ipv6_enabled = var.hetzner_ip_config.ipv6_enabled
  }

  connection {
    host        = self.ipv4_address
    user        = var.ssh_username
    type        = "ssh"
    private_key = var.ssh_private_key
  }
  provisioner "file" {
    source      = "${path.module}/scripts/remote/setup-runner.sh"
    destination = "/srv/setup-runner.sh"
  }
  provisioner "file" {
    source      = "${path.module}/scripts/remote/gh-runner-cli"
    destination = "/srv/gh-runner-cli"
  }
  provisioner "file" {
    source      = "${path.module}/scripts/remote/install.sh"
    destination = "/srv/install.sh"
  }

  # remote package installations
  provisioner "remote-exec" {
    inline = [
      # install additional packages
      "sh /srv/install.sh ${local.default_package_list} ${var.hetzner_machine_additional_packages}",
      # install docker
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      "curl -sL https://deb.nodesource.com/setup_${var.nodejs_version}.x | sudo -E bash -",
      "apt install nodejs",
    ]
  }

  # remote github runner setup
  provisioner "remote-exec" {
    inline = [
      "mkdir /srv/actions-runner && cd /srv/actions-runner",
      "curl -L https://github.com/actions/runner/releases/download/v${var.github_runner_release}/actions-runner-linux-x64-${var.github_runner_release}.tar.gz -o actions-runner-linux-x64-${var.github_runner_release}.tar.gz",
      "tar xzf ./actions-runner-linux-x64-${var.github_runner_release}.tar.gz",
      "adduser github-runner --disabled-login --gecos ''",
      "usermod -aG docker github-runner",
      "echo 'github-runner   ALL=(ALL:ALL)NOPASSWD:ALL' > /etc/sudoers.d/github-runner",
      "chown -R github-runner /srv",
      "chmod +x /srv/setup-runner.sh /srv/gh-runner-cli",
      "mv /srv/actions-runner/run.sh /srv/actions-runner/run.sh.old",
      "su github-runner -c 'export CUSTOM_HOSTNAME=${self.name}; export GH_USERNAME=${var.github_authentication_user}; export GH_TOKEN=${var.github_authentication_token}; export GH_OWNER=${var.github_owner}; export GH_NAME=${var.github_repository_name}; export GH_LABELS=${var.github_actions_runner_labels}; export GH_REPLACE_RUNNERS=${var.github_actions_runner_replace_existing}; export GH_RUNNER_TYPE=${var.github_runner_type}; /srv/setup-runner.sh'"
    ]
  }

  timeouts {
    create = "10m"
  }
}

resource "null_resource" "deprovision" {
  triggers = {
    machine_names      = join(",", tolist(hcloud_server.github_runner.*.name))
    github_user        = var.github_authentication_user
    github_user_token  = var.github_authentication_token
    github_repo_name   = var.github_repository_name
    github_repo_owner  = var.github_owner
    github_runner_type = var.github_runner_type
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/local/destroy_runner.sh ${self.triggers.machine_names} ${self.triggers.github_user} ${self.triggers.github_user_token} ${self.triggers.github_repo_name} ${self.triggers.github_repo_owner} ${self.triggers.github_runner_type}"
  }
}
