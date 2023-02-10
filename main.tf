module "vpc_network" {
  source = "./modules/network"

  vpc_name = "${var.vpc_name}"
  subnets_name = var.subnets_name
  az = var.az_list
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
}