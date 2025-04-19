terraform {
  required_version = "1.11.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  application_name = "terraapp2"
  environment_name = "dev"

  dashed_name     = "${local.application_name}-${local.environment_name}"
  continuous_name = "${local.application_name}${local.environment_name}"
}
