#This cinfiguration is for creating multiple resources using count meta-argument

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



resource "azurerm_resource_group" "new_rg" {
  name     = "roopa_rg"
  location = "West US 2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.new_rg.location
  resource_group_name = azurerm_resource_group.new_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.new_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  count               = 3
  name                = "nic-${count.index + 1}"
  location            = azurerm_resource_group.new_rg.location
  resource_group_name = azurerm_resource_group.new_rg.name

  ip_configuration {
    name                          = "internal-${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               =2 
  name                = "vm-${count.index + 1}"
  location            = azurerm_resource_group.new_rg.location
  resource_group_name = azurerm_resource_group.new_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
