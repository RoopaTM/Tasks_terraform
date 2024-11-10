# Required Providers and Configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.6.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "547278e7-01d9-4f7c-9e1d-b32e9dc1d729"
}




#fetch existing resource group and refer that using data source block
data "azurerm_resource_group" "registry" {
  name = "Roopa-azure" #This resource group already exist in azure cloud
}

resource "azurerm_container_registry" "tfreg" {
  name                = "roopareg"
  resource_group_name = data.azurerm_resource_group.registry.name
  location            = data.azurerm_resource_group.registry.location
  sku                 = "Premium"
  admin_enabled       = true
}

output "adminpwd" {
  value = azurerm_container_registry.tfreg.admin_password

  sensitive = true
}


resource "azurerm_container_registry_token" "token" {
  name                    = "token"
  container_registry_name = azurerm_container_registry.tfreg.name
  resource_group_name     = data.azurerm_resource_group.registry.name
  scope_map_id            = azurerm_container_registry_scope_map.scope.id
}

data "azurerm_container_registry_scope_map" "scope" {
  name                    = "_repositories_pull"
  resource_group_name     = data.azurerm_resource_group.registry.name
  container_registry_name = azurerm_container_registry.tfreg.name
}

resource "azurerm_container_registry_token_password" "pwd" {
  container_registry_token_id = azurerm_container_registry_token.token.id

  password1 {
    expiry = "2024-18-02T17:57:36+08:00"
  }
}



