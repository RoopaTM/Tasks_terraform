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

resource "azurerm_mysql_flexible_server" "sqldbnew1" {
  name                   = "sqldb-flexible-server"
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  administrator_login    = "roopa"
  administrator_password = "Roopatm@1234"
  sku_name               = "B_Standard_B1s"
}

resource "azurerm_mysql_flexible_database" "mysqldbnew" {
  name                = "mysqldb"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.sqldbnew1.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
