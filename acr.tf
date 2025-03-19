resource "azurerm_container_registry" "acr" {
  name                = "acrprojetoada"
  resource_group_name = azurerm_resource_group.grupo-recursos-ada.name
  location            = azurerm_resource_group.grupo-recursos-ada.location
  sku                 = "Basic"
  admin_enabled       = true
}
