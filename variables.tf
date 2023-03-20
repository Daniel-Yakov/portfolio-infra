# provider
variable "region" {
  description = "The aws region"
  type = string
}

############################## vpc module vars ##############################
variable "vpc_name" {
  description = "VPC name to create"
  type = string
}

variable "subnets_name" {
  type        = list(string)
  description = "list of subnets names to create"
}

############################## EKS module vars ##############################
variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

# node group
variable "node_group" {
  type = object({
    name = string
    instance_types = list(string)
    desired_size = number
    max_size     = number
    min_size     = number
    max_unavailable = number
  })
  description = "node group configuration"
}

# csi driver
variable "csi_driver" {
  type = object({
    addon_version = string
    role_name = string
  })
  description = "Allows pvc from ebs on aws"
}

############################## cert_manager_tls_role module vars ##############################
variable "cert_manager_solver_role_name" {
  type        = string
  description = "Role name for the cert manager solver (pass the challenge)"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53 host zone id"
}

############################## sealed-secrets module vars ##############################
variable "sealed_secrets_key_name" {
  type = string
  description = "Name of sealed secret key"
}

variable "sealed_secret_namespace" {
  type = string
  description = "Namespace for the sealed secrets to be deployed"
}

################################# ArgoCD module vars #################################
# argocd_helm_chart
variable "argocd_helm_chart" {
  type = object({
    release_name = string
    repository = string
    chart = string
    namespace = string
    version = string
    create_namespace = bool
  })
  description = "ArgoCD helm chart configuration"
}

# github_connection
variable "github_connection" {
  type = object({
    name = string
    namespace = string
    github_url = string
    path_to_ssh_key = string
  })
  description = "The secret holding credentainls to connect to github repo"
}

# argocd_apps_helm_chart
variable "argocd_apps_helm_chart" {
  type = object({
    release_name = string
    repository = string
    chart = string
    namespace = string
    version = string
    create_namespace = bool
    path_to_application_file = string
  })
  description = "ArgoCD-apps helm chart configuration"
}