output "print_machine_names_master" {
  value = hcloud_server.github_runner.*.name
}

output "print_machine_ipv4_master" {
  value = hcloud_server.github_runner.*.ipv4_address
}