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

variable "github_connection" {
  type = object({
    name = string
    namespace = string
    github_url = string
    path_to_ssh_key = string
  })
  description = "The secret holding credentainls to connect to github repo"
}

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