region = "eu-central-1"

############################## vpc module vars ##############################
vpc_name  = "daniel-eks"
subnets_name = [ "daniel-1a-pub", "daniel-1b-pub" ]

############################## EKS module vars ##############################
cluster_name = "daniel-portfolio-cluster"

# node group
node_group = {
    name = "daniel-portfolio-nodegroup"
    instance_types = [ "t3.xlarge" ]
    desired_size = 2
    max_size     = 2
    min_size     = 1
    max_unavailable = 1
}

# csi driver
csi_driver = {
    addon_version = "v1.15.0-eksbuild.1"
    role_name = "daniel-eks-ebs-csi-driver"
}

############################## cert_manager_tls_role module vars ##############################
cert_manager_solver_role_name = "daniel-cert-manager-route53"
hosted_zone_id = "Z008113119LG8LRMHDNY0"

############################## sealed-secrets module vars ##############################
sealed_secrets_key_name = "sealed-secrets-key"
sealed_secret_namespace = "security"

################################# ArgoCD module vars #################################
# argocd_helm_chart
argocd_helm_chart = {
    release_name = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart = "argo-cd"
    namespace = "argocd"
    version = "5.20.3"
    create_namespace = true
}

# github_connection
github_connection = {
    name = "gitops-config-private-repo"
    namespace = "argocd"
    github_url = "git@github.com:Daniel-Yakov/employees-gitops-config.git"
    path_to_ssh_key = "~/.ssh/argocd"
}

# argocd_apps_helm_chart
argocd_apps_helm_chart = {
    release_name = "argocd-apps"
    repository = "https://argoproj.github.io/argo-helm"
    chart = "argocd-apps"
    namespace = "argocd"
    version = "0.0.8"
    create_namespace = true
    path_to_application_file = "argocd/applications.yml"
}