locals {
  fill_char_length = 64-length("github-runner")-4
}

resource "random_string" "hetzner_machine" {
  length           = local.fill_char_length > 0 ? local.fill_char_length : 0
  special          = false
}

resource "hcloud_server" "github_runner" {
  count       = var.github_actions_runner_count
  name        = format("%s-%s-%d", "github-runner", random_string.hetzner_machine.result, count.index + 1)
  server_type = var.hetzner_machine_type
  image       = var.hetzner_machine_os
  location    = var.hetzner_machine_location
  ssh_keys    = concat([hcloud_ssh_key.admin_ssh_key.id], var.hetzner_additional_public_key_ids)

  connection {
    host        = self.ipv4_address
    user        = var.ssh_username
    type        = "ssh"
    private_key = file(var.ssh_private_key)
  }
  provisioner "file" {
    source      = "scripts/remote/setup-runner.sh"
    destination = "/srv/setup-runner.sh"
  }

  provisioner "file" {
    source      = "scripts/remote/gh-runner-cli"
    destination = "/srv/gh-runner-cli"
  }

  provisioner "remote-exec" {
    inline = [
        "apt-get update -y", 
        "DEBIAN_FRONTEND=noninteractive apt-get upgrade -y", 
        "DEBIAN_FRONTEND=noninteractive apt-get install sudo git vim tmux apt-transport-https ca-certificates curl gnupg lsb-release pass ${var.hetzner_machine_additional_packages} -y",
        "echo '127.0.0.1       fylr-server-postgres    fylr-server-sqlite      execserver      minio2  postgres2       elasticsearch2' >> /etc/hosts",
        "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
        "echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian buster stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
        "apt-get update -y",
        "apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y",
        "curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -",
        "apt install nodejs",
        "mkdir /srv/actions-runner && cd /srv/actions-runner",
        "curl -o actions-runner-linux-x64-2.277.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.277.1/actions-runner-linux-x64-2.277.1.tar.gz",
        "tar xzf ./actions-runner-linux-x64-2.277.1.tar.gz",
        "adduser github-runner --disabled-login --gecos ''",
        "usermod -aG docker github-runner",
        "echo 'github-runner   ALL=(ALL:ALL)NOPASSWD:ALL' > /etc/sudoers.d/github-runner",
        "chown -R github-runner /srv",
        "chmod +x /srv/setup-runner.sh /srv/gh-runner-cli",
        "mv /srv/actions-runner/run.sh /srv/actions-runner/run.sh.old",
        "su github-runner -c 'export CUSTOM_HOSTNAME=${self.name}; export GH_USERNAME=${var.github_authentication_user}; export GH_TOKEN=${var.github_authentication_token}; export GH_OWNER=${var.github_owner}; export GH_NAME=${var.github_repository_name}; export GH_LABELS=${var.github_actions_runner_labels}; export GH_REPLACE_RUNNERS=${var.github_actions_runner_replace_existing}; export GH_RUNNER_TYPE=${var.github_runner_type}; /srv/setup-runner.sh'"
        ]
  }
}

resource "null_resource" "deprovision" {
  triggers = {
    machine_names = join(",", tolist(hcloud_server.github_runner.*.name))
    github_user = var.github_authentication_user
    github_user_token = var.github_authentication_token
    github_repo_name = var.github_repository_name
    github_repo_owner = var.github_owner
    github_runner_type = var.github_runner_type
  }

  provisioner "local-exec" {
      when = destroy
      command = "./scripts/local/destroy_runner.sh ${self.triggers.machine_names} ${self.triggers.github_user} ${self.triggers.github_user_token} ${self.triggers.github_repo_name} ${self.triggers.github_repo_owner} ${self.triggers.github_runner_type}"
  }
}