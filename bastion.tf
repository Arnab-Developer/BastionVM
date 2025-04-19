resource "azurerm_public_ip" "main" {
  name                = "pip-${local.dashed_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

resource "azurerm_bastion_host" "main" {
  name                = "bastion-${local.dashed_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                 = "ipconfig-${local.dashed_name}-bastion"
    subnet_id            = azurerm_subnet.main[1].id
    public_ip_address_id = azurerm_public_ip.main.id
  }
}
