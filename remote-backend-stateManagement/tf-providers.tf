# Terraform required providers block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.6.0"
    }
  }


 # Backend configuration to store state remotely in Azure Storage Account
  backend "azurerm" {
    resource_group_name  = "roopatm2_terraform_rg"
    storage_account_name = "remotebackendroopa"
    container_name       = "tfstatemanage"
    key                  = "terraform.tfstate"
  }
}




# Azure Provider Configuration
provider "azurerm" {
  features {}
  subscription_id = "547278e7-01d9-4f7c-9e1d-b32e9dc1d729"
}
