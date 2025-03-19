resource "kubernetes_deployment" "app" {
  metadata {
    name      = "app-deployment"
    namespace = "namespace"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "app"
      }
    }

    template {
      metadata {
        labels = {
          app = "app"
        }
      }

      spec {
        container {
          name  = "app"
          image = "acrprojetoada.azurecr.io/schwendler/embarque-ti-spd-project:v1"

          env {
            name  = "SPD_KEY_VAULT_URI"
            value = azurerm_key_vault.kv.vault_uri
          }

          env {
            name  = "DB_CONNECTION_STRING"
            value = azurerm_key_vault_secret.db_connection_string.value
          }
          env {
            name  = "ASPNETCORE_ENVIRONMENT"
            value = "Development" # Habilita modo DEV, quando corrigir o problema da pg, desabilite aqui!
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "app-service"
    namespace = "namespace"
  }

  spec {
    selector = {
      app = "app"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
