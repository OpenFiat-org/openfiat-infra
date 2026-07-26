terraform {
  required_version = ">= 1.7"
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
