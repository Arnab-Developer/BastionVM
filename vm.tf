resource "azurerm_network_interface" "main" {
  name                = "nic-${local.dashed_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "ipconfig-${local.dashed_name}-vm"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.main[0].id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "vm-${local.dashed_name}"
  size                            = "Standard_D2s_v3"
  admin_username                  = "adminuser"
  admin_password                  = "" # Removed for security reasons.
  disable_password_authentication = false
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location

  network_interface_ids = [azurerm_network_interface.main.id]

  os_disk {
    name                 = "osdisk-${local.dashed_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "main" {
  name                 = "disk-${local.dashed_name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  managed_disk_id    = azurerm_managed_disk.main.id
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "main" {
  name                 = "vmext-${local.dashed_name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  virtual_machine_id   = azurerm_linux_virtual_machine.main.id

  settings = <<SETTINGS
  {
    "commandToExecute": "sudo snap install docker"
  }
  SETTINGS
}
