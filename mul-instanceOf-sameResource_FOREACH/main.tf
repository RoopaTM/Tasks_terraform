#This configuration is to create multiple instance using for each 

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

# Create a new Resource Group in the Australia East region
resource "azurerm_resource_group" "roopa_resource_group" {
  name     = "RG-terraform-rooptm"
  location = "Australia East"
}

# Create a Virtual Network in the new Resource Group
resource "azurerm_virtual_network" "my_vnet" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
}

# Create a Subnet in the new Virtual Network
resource "azurerm_subnet" "my_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.roopa_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define VM instances (2 Windows VMs and 1 Linux VM)
locals {
  vms = {
    "vm1" = {
      os             = "windows"
      admin_username = "adminuser"
      admin_password = "Roopatm@123"
    },
    "vm2" = {
      os             = "windows"
      admin_username = "adminuser"
      admin_password = "Shilpatm@123"
    },
    "vm3" = {
      os             = "linux"
      admin_username = "adminuser"
      admin_ssh_key  = file("~/.ssh/id_rsa.pub")
    }
  }
}

# Create Public IPs  3 instances are created one for each VM
resource "azurerm_public_ip" "my_public_ip" {
  for_each = local.vms

  name                = "myPublicIP-${each.key}"
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Network Interfaces for each VM
resource "azurerm_network_interface" "my_nic" {
  for_each = local.vms

  name                = "myNic-${each.key}"
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name

  ip_configuration {
    name                          = "myIpConfiguration-${each.key}"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip[each.key].id
  }
}

# Create Windows VMs (vm1 and vm2)----> 2 instance are created
resource "azurerm_windows_virtual_machine" "my_windows_vm" {
  for_each = { for key, value in local.vms : key => value if value.os == "windows" }     #for_each = { for key, value in local.vms : key => value if value.os == "wi                                                                                       dows" } creates only the VMs that have the OS type windows (i.e., vm1 and vm2 
  name                = "vm-${each.key}"
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  location            = azurerm_resource_group.roopa_resource_group.location
  size                = "Standard_DS1_v2"
  network_interface_ids = [
    azurerm_network_interface.my_nic[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  # Admin username and password for Windows VMs
  admin_username = each.value.admin_username
  admin_password = each.value.admin_password
}



# Create Linux VM (for vm3)
resource "azurerm_linux_virtual_machine" "my_linux_vm" {
  for_each = { for key, value in local.vms : key => value if value.os == "linux" }   #creates only the VM with the OS type linux (i.e., vm3).

  name                = "vm-${each.key}"
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  location            = azurerm_resource_group.roopa_resource_group.location
  size                = "Standard_DS1_v2"
  network_interface_ids = [
    azurerm_network_interface.my_nic[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
}




  # Admin username and SSH key for Linux VM
  admin_username = each.value.admin_username
  admin_ssh_key {
    username   = each.value.admin_username
    public_key = each.value.admin_ssh_key
  }
}

# Output the public IP addresses of the VMs
output "public_ip_vm" {
  value = {
    for vm, ip in azurerm_public_ip.my_public_ip : vm => ip.ip_address
  }
}

