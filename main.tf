module "vpc_network" {
  source = "./modules/network"

  vpc_name = "${var.vpc_name}"
  subnets_name = var.subnets_name
}

# EKS cluster
module "eks" {
  source = "./modules/eks"

  eks_cluster_name = var.cluster_name
  subnets = module.vpc_network.subnets_ids
  node_group = {
    name = var.node_group_name
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
    max_unavailable = var.max_unavailable
  }

  depends_on = [ module.vpc_network ]
}

# the Role that allows to cert-manager resolve the tls challenge (access to route53)
module "cert_manager_tls_role" {
  source = "./modules/tls-role"

  cert_manager_solver_role_name = "daniel-cert-manager-route53"
  node_group_role_arn = module.eks.node_group_arn
  hosted_zone_id = "Z09020131AOXZ3LFNC5KB"
}

# create the secret for sealed-secret key
module "sealed-secrets" {
  source = "./modules/sealed-secret"

  namespace = var.namespace

  depends_on = [ module.eks ]
}

# ArgoCD
resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.20.3"
  create_namespace = true

  depends_on = [ module.eks ]
}

# Config the connection to the github repository
resource "kubernetes_secret" "argocd-github-connection" {  
  metadata {
    name      = "gitops-config-private-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    "type" = "git"
    "url" = "git@github.com:Daniel-Yakov/employees-gitops-config.git"
    "sshPrivateKey" = file("~/.ssh/argocd3")
  }

  depends_on = [
    helm_release.argocd
  ]
}

# Create infra apps
resource "helm_release" "argocd-apps-infra" {
  name       = "argocd-apps-infra"
  
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  namespace  = "argocd"
  version = "0.0.8"  

  values = [
    file("argocd/infra-applications.yml")
  ]

  depends_on = [
    helm_release.argocd
  ]
}

# Create employees app
resource "helm_release" "argocd-apps-employees" {
  name       = "argocd-apps-employees"
  
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  namespace  = "argocd"
  version = "0.0.8"  

  values = [
    file("argocd/employees.yml")
  ]

  depends_on = [
    helm_release.argocd-apps-infra
  ]
}