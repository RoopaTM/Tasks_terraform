#This configuratiopn is for creating postgresql db

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


data "azurerm_resource_group" "rg" {
  name = "Roopa-azure" #This resource group already exist in azure cloud
} 


resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "postgresql-db-rtm"
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  administrator_login    = "citus"           
  administrator_password = "Roopatm@1234"        
  version                = "16"                
   sku_name               = "GP_Standard_D2s_v3"
  storage_mb             = 32768               

  public_network_access_enabled = true
}

resource "azurerm_postgresql_flexible_server_database" "sqldatabase" {
  name                = "db"
 server_id = azurerm_postgresql_flexible_server.db.id
}
