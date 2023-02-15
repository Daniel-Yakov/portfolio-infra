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
  node_group = var.node_group
  csi_driver = var.csi_driver

  depends_on = [ module.vpc_network ]
}

# the Role that allows to cert-manager resolve the tls challenge (access to route53)
module "cert_manager_tls_role" {
  source = "./modules/tls-role"

  cert_manager_solver_role_name = var.cert_manager_solver_role_name
  node_group_role_arn = module.eks.node_group_arn
  hosted_zone_id = var.hosted_zone_id
  
  depends_on = [ module.eks ]
}

# create the secret for sealed-secret key
module "sealed-secrets" {
  source = "./modules/sealed-secret"

  sealed_secrets_key_name = var.sealed_secrets_key_name
  namespace = var.sealed_secret_namespace

  depends_on = [ module.eks ]
}

# Create and config ArgoCD and Applications
module "argocd" {
  source = "./modules/argocd"

  argocd_helm_chart = var.argocd_helm_chart
  github_connection = var.github_connection
  argocd_apps_helm_chart = var.argocd_apps_helm_chart

  depends_on = [ module.eks ]
}