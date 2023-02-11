output "network" {
  value = {
    vpc_id = module.vpc_network.vpc_id
    subnets_id = module.vpc_network.subnets_ids
  }
}

output "eks_cluster" {
  value = {
    cluster_id = module.eks.cluster_id
    node_group_id = module.eks.node_group_id
  }
}

output "kube_config_cluster_name" {
  value = module.eks.cluster_name
}

output "kube_config_region" {
  value = var.region
  
}