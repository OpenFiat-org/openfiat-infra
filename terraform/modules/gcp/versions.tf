terraform {
  required_version = ">= 1.7"
  required_providers {
    gcp = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
