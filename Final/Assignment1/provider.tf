# provider.tf
locals {
  versions = jsondecode(file("${path.module}/versions.hcl"))
}

terraform {
  required_version = local.versions.terraform_version

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = local.versions.provider_versions.azurerm
    }

    random = {
      source  = "hashicorp/random"
      version = local.versions.provider_versions.random
    }

    tls = {
      source  = "hashicorp/tls"
      version = local.versions.provider_versions.tls
    }

  }
}