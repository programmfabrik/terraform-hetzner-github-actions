terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = ">= 1.35.1"
    }
  }
  required_version = ">= v1.2.9"
}
