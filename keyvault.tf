data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv" {
  name                       = "kv-desafio-aks"
  location                   = azurerm_resource_group.grupo-recursos-ada.location
  resource_group_name        = azurerm_resource_group.grupo-recursos-ada.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7    # Habilita Soft Delete como boas práticas
  purge_protection_enabled   = true # Habilita Purge Protection como boas práticas

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
  }

  #Politica de acesso para AKS let segredos do key vault
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

    secret_permissions = [
      "Get", "List"
    ]
  }
}
