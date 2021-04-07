resource "hcloud_server" "github_runner" {
  count       = var.github_actions_runner_count
  name        = format("%s-%s-%d", "github-runner", var.hetzner_machine_os, count.index + 1)
  server_type = var.hetzner_machine_type
  image       = var.hetzner_machine_os
  ssh_keys    = [hcloud_ssh_key.admin_ssh_key.id]

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

  provisioner "remote-exec" {
    inline = [
        "apt-get update -y", 
        "DEBIAN_FRONTEND=noninteractive apt-get upgrade -y", 
        "DEBIAN_FRONTEND=noninteractive apt-get install sudo git vim tmux apt-transport-https ca-certificates curl gnupg lsb-release gcc build-essential ffmpeg imagemagick sqlite3 libopenjp2-tools libopenjp2-7 libopenjp2-7-dev rsync make pkg-config exiftool ghostscript xsltproc -y",
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
        "chown -R github-runner. /home/github-runner/.ssh",
        "usermod -aG docker github-runner",
        "echo 'github-runner   ALL=(ALL:ALL)NOPASSWD:ALL' > /etc/sudoers.d/github-runner",
        "chown -R github-runner /srv",
        "chmod +x /srv/setup-runner.sh",
        "su github-runner -c '/srv/setup-runner.sh ${var.github_actions_provision_url} ${var.github_actions_provision_token} ${var.github_actions_runner_labels} ${var.github_actions_runner_replace_existing}'"
        ]
  }
}
