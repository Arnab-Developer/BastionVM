resource "azurerm_resource_group" "main" {
  name     = "rg-${local.dashed_name}"
  location = "North Europe"
}
