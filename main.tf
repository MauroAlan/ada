data "azurerm_resource_group" "grupo-recursos-ada" {
  name = "grupo-de-recursos-ada"
}
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-cluster"
  location            = data.azurerm_resource_group.grupo-recursos-ada.location
  resource_group_name = data.azurerm_resource_group.grupo-recursos-ada.name
  dns_prefix          = "aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "production"
  }
}