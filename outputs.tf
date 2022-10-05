output "runner_machine_names" {
  value = module.hetzner_gh_runners.runner_machine_names
}

output "runner_ipv4_addresses" {
  # create output with value if either one of the IP types are set
  value = module.hetzner_gh_runners.runner_ipv4_addresses
}

output "runner_ipv6_addresses" {
  value = module.hetzner_gh_runners.runner_ipv6_addresses
}