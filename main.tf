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
    instance_types = var.instance_types
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
    max_unavailable = var.max_unavailable
  }
  csi_driver = {
    addon_version = var.addon_version
    role_name = var.csi_driver_role_name
  }

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

  argocd_helm_chart = {
    release_name = var.argocd_helm_chart_release_name
    repository = var.argocd_helm_chart_repository
    chart = var.argocd_helm_chart_chart
    namespace = var.argocd_helm_chart_namespace
    version = var.argocd_helm_chart_version
    create_namespace = var.argocd_helm_chart_create_namespace
  } 

  github_connection = {
    name = var.github_connection_name
    namespace = var.github_connection_namespace
    github_url = var.github_connection_url
    path_to_ssh_key = var.github_connection_path_to_ssh_key
  }

  argocd_apps_helm_chart = {
    release_name = var.argocd_apps_helm_chart_release_name
    repository = var.argocd_apps_helm_chart_repository
    chart = var.argocd_apps_helm_chart_chart
    namespace = var.argocd_apps_helm_chart_namespace
    version = var.argocd_apps_helm_chart_version
    create_namespace = var.argocd_apps_helm_chart_create_namespace
    path_to_application_file = var.argocd_apps_helm_chart_path_to_application_file
  }

  depends_on = [ module.eks ]
}