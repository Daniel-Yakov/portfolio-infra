# provider
variable "region" {
  description = "The aws region"
  type = string
  default = "eu-west-3"
}

############################## vpc module vars ##############################
variable "vpc_name" {
  description = "VPC name to create"
  type = string
  default = "daniel-eks"
}

variable "subnets_name" {
  type        = list(string)
  default     = [ "daniel-1a-pub", "daniel-1b-pub" ]
  description = "list of subnets names to create"
}

############################## EKS module vars ##############################
variable "cluster_name" {
  type        = string
  default     = "daniel-portfolio-cluster"
  description = "EKS cluster name"
}

# node group
variable "node_group_name" {
  type        = string
  default     = "daniel-portfolio-nodegroup"
  description = "Node group name"
}

variable "instance_types" {
  type = list(string)
  default = [ "t3a.2xlarge" ]
  description = "instance type for the instances in the node group"
}

variable "desired_size" {
  type        = number
  default     = 3
  description = "desired size of ec2 for the node group name"
}

variable "max_size" {
  type        = number
  default     = 3
  description = "Max size of ec2 for the node group name"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Min size of ec2 for the node group name"
}

variable "max_unavailable" {
  type        = number
  default     = 1
  description = "Number of nodes allowed to not be available (during upgrades for example)"
}

# csi driver
variable "addon_version" {
  type        = string
  default     = "v1.15.0-eksbuild.1"
  description = "EBS csi driver add-on version"
}

variable "csi_driver_role_name" {
  type        = string
  default     = "daniel-eks-ebs-csi-driver"
  description = "EBS csi driver role name"
}

############################## cert_manager_tls_role module vars ##############################
variable "cert_manager_solver_role_name" {
  type        = string
  default     = "daniel-cert-manager-route53"
  description = "Role name for the cert manager solver (pass the challenge)"
}

variable "hosted_zone_id" {
  type        = string
  default     = "Z09020131AOXZ3LFNC5KB"
  description = "Route53 host zone id"
}

############################## sealed-secrets module vars ##############################
variable "sealed_secrets_key_name" {
  type = string
  default = "sealed-secrets-key"
  description = "Name of sealed secret key"
}

variable "sealed_secret_namespace" {
  type = string
  default = "security"
  description = "Namespace for the sealed secrets to be deployed"
}

################################# ArgoCD module vars #################################
# argocd_helm_chart
variable "argocd_helm_chart_release_name" {
  type = string
  default = "argocd"
  description = "Release name for the ArgoCD helm chart"
}

variable "argocd_helm_chart_repository" {
  type = string
  default = "https://argoproj.github.io/argo-helm"
  description = "The repo of the ArgoCD helm chart"
}

variable "argocd_helm_chart_chart" {
  type = string
  default = "argo-cd"
  description = "The chart name from repo of the ArgoCD helm chart"
}

variable "argocd_helm_chart_namespace" {
  type = string
  default = "argocd"
  description = "Namespace to depoly the chart into"
}

variable "argocd_helm_chart_version" {
  type = string
  default = "5.20.3"
  description = "The chart version"
}

variable "argocd_helm_chart_create_namespace" {
  type = bool
  default = true
  description = "Create namespace(?)"
}

# github_connection
variable "github_connection_name" {
  type = string
  default = "gitops-config-private-repo"
  description = "GitHub connection name (the name of the secret)"
}

variable "github_connection_namespace" {
  type = string
  default = "argocd"
  description = "Secret namespace"
}

variable "github_connection_url" {
  type = string
  default = "git@github.com:Daniel-Yakov/employees-gitops-config.git"
  description = "GitHub url"
}

variable "github_connection_path_to_ssh_key" {
  type = string
  default = "~/.ssh/argocd3"
  description = "Path to the ssh key for credentainls to the github repo"
}

# argocd_apps_helm_chart
variable "argocd_apps_helm_chart_release_name" {
  type = string
  default = "argocd-apps"
  description = "Release name for the ArgoCD-Apps helm chart"
}

variable "argocd_apps_helm_chart_repository" {
  type = string
  default = "https://argoproj.github.io/argo-helm"
  description = "The repo of the ArgoCD-Apps helm chart"
}

variable "argocd_apps_helm_chart_chart" {
  type = string
  default = "argocd-apps"
  description = "The chart name from repo of the ArgoCD-Apps helm chart"
}

variable "argocd_apps_helm_chart_namespace" {
  type = string
  default = "argocd"
  description = "Namespace to depoly the chart into"
}

variable "argocd_apps_helm_chart_version" {
  type = string
  default = "0.0.8"
  description = "The chart version"
}

variable "argocd_apps_helm_chart_create_namespace" {
  type = bool
  default = true
  description = "Create namespace(?)"
}

variable "argocd_apps_helm_chart_path_to_application_file" {
  type = string
  default = "argocd/applications.yml"
  description = "path to the application definition file"
}