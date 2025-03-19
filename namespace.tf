resource "kubernetes_namespace" "app" {
  metadata {
    name = "namespace"
  }
}