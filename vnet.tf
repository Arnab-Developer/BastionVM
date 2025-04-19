resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.dashed_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  address_space = ["10.0.0.0/16"]
}

locals {
  subnets = [
    {
      name           = "snet-${local.dashed_name}-vm"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "AzureBastionSubnet"
      address_prefix = "10.0.2.0/24"
    }
  ]
}

resource "azurerm_subnet" "main" {
  for_each = { for i, v in local.subnets : i => v }

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [each.value.address_prefix]
}
