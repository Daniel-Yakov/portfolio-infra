module "vpc_network" {
  source = "./modules/network"

  vpc_name = "${var.vpc_name}-${terraform.workspace}"
  subnets_name = var.subnets_name
  az = var.az_list
}