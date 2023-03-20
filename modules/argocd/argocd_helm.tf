# ArgoCD
resource "helm_release" "argocd" {
  name  = var.argocd_helm_chart.release_name

  repository       = var.argocd_helm_chart.repository
  chart            = var.argocd_helm_chart.chart
  namespace        = var.argocd_helm_chart.namespace
  version          = var.argocd_helm_chart.version
  create_namespace = var.argocd_helm_chart.create_namespace
}

# Config the connection to the github repository
resource "kubernetes_secret" "argocd-github-connection" {  
  metadata {
    name      = var.github_connection.name
    namespace = var.github_connection.namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    "type" = "git"
    "url" = var.github_connection.github_url
    "sshPrivateKey" = file(var.github_connection.path_to_ssh_key)
  }

  depends_on = [ helm_release.argocd ]
}

# Create infra apps
resource "helm_release" "argocd-apps" {
  name       = var.argocd_apps_helm_chart.release_name
  
  repository = var.argocd_apps_helm_chart.repository
  chart      = var.argocd_apps_helm_chart.chart
  namespace  = var.argocd_apps_helm_chart.namespace
  version    = var.argocd_apps_helm_chart.version

  values = [
    file(var.argocd_apps_helm_chart.path_to_application_file)
  ]

  depends_on = [ helm_release.argocd ]
}