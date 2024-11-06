resource "azurerm_resource_group" "roopa_resource_group" {
  name     = var.resourcegroup_name
  location = var.location
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
}

resource "azurerm_subnet" "my_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.roopa_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "my_public_ip_linux" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "my_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name

  ip_configuration {
    name                          = "myIpConfiguration"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip_linux.id
  }
}




resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  location            = azurerm_resource_group.roopa_resource_group.location
  size                = var.size
  admin_username      = var.user

  admin_ssh_key {
    username   = var.user
    public_key = file("~/.ssh/my_azure_key.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.my_nic.id,
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
}

