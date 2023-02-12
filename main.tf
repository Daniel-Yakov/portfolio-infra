module "vpc_network" {
  source = "./modules/network"

  vpc_name = "${var.vpc_name}"
  subnets_name = var.subnets_name
}

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

module "cert_manager_tls_role" {
  source = "./modules/tls-role"

  cert_manager_solver_role_name = "daniel-cert-manager-route53"
  node_group_role_arn = module.eks.node_group_arn
  hosted_zone_id = "Z09020131AOXZ3LFNC5KB"
}

module "sealed-secrets" {
  source = "./modules/sealed-secret"

  namespace = var.namespace

  depends_on = [ module.eks ]
}

resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.20.3"
  create_namespace = true

  depends_on = [ module.eks ]
}

resource "helm_release" "argocd-apps" {
  name       = "argocd-apps"
  
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  namespace  = "argocd"
  version = "0.0.8"  

  values = [
    file("argocd/applications.yml")
  ]

  depends_on = [
    helm_release.argocd
  ]
}