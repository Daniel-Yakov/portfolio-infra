resource "kubernetes_namespace" "sealed-secrets-ns" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "sealed-secrets-key" {
  depends_on = [ kubernetes_namespace.sealed-secrets-ns ]
  
  metadata {
    name      = var.sealed_secrets_key_name
    namespace = var.namespace
  }
  data = {
    "tls.crt" = file("keys/tls.crt")
    "tls.key" = file("keys/tls.key")
  }
  type = "kubernetes.io/tls"
}