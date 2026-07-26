terraform {
  required_version = ">= 1.7"
  required_providers {
    hetzner = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}
