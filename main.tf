resource "azurerm_resource_group" "grupo-recursos-ada" {
  name     = "grupo-de-recursos-ada"
  location = "brazilsouth"
}
data "azurerm_resource_group" "grupo-recursos-ada" {
  name = "grupo-de-recursos-ada"
}
#Criacao do AKS
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-cluster"
  resource_group_name = azurerm_resource_group.grupo-recursos-ada.name
  location            = azurerm_resource_group.grupo-recursos-ada.location
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
#Integração entre AKS E ACR
resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
