provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "RG-VM-COST"
  location = "West Europe"
}

resource "azurerm_public_ip" "ip" {
  name                = "vmdemo-pip-cost"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

data "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = "RG_NETWORK"
  virtual_network_name = "VNET_TEST"
}

resource "azurerm_network_interface" "nic" {
  name                = "vmdemo-nic-cost"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
}




resource "azurerm_virtual_machine" "main" {
  name                  = "myvmdemocost"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdiskvm1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "myvmdemo"
    admin_username = "testdemo"
    admin_password = "Password123!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}
