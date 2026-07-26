terraform {
  required_version = ">= 1.7"
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.35"
    }
  }
}
