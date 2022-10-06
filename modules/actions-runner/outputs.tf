output "runner_machine_names" {
  value = hcloud_server.github_runner.*.name
}

output "runner_ipv4_addresses" {
  # create output with value if either one of the IP types are set
  value = var.hetzner_ip_config.ipv4_enabled == false && var.hetzner_ip_config.ipv6_enabled == false ? hcloud_server.github_runner.*.ipv4_address : var.hetzner_ip_config.ipv4_enabled ? hcloud_server.github_runner.*.ipv4_address : []
}

output "runner_ipv6_addresses" {
  value = var.hetzner_ip_config.ipv6_enabled ? hcloud_server.github_runner.*.ipv6_address : []
}