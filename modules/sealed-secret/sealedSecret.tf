resource "kubernetes_namespace" "sealed-secrets-ns" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "sealed-secrets-key" {
  depends_on = [ kubernetes_namespace.sealed-secrets-ns ]
  
  metadata {
    name      = "sealed-secrets-key"
    namespace = var.namespace
  }
  data = {
    "tls.crt" = file("keys/tls.crt")
    "tls.key" = file("keys/tls.key")
  }
  type = "kubernetes.io/tls"
}

resource "helm_release" "sealed-secrets" {
  depends_on = [ kubernetes_secret.sealed-secrets-key ]
  
  name       = "sealed-secrets"

  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  namespace  = var.namespace
  version    = "2.7.3"
}