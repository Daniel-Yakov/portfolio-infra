variable "eks_cluster_name" {
  description = "cluster name"
  type = string
}

variable "subnets" {
  description = "cluster subnets"
  type = list(string)
}

variable "node_group" {
  description = "cluster subnets"
  type = object({
    name = string
    instance_types = list(string)
    desired_size = number
    max_size     = number
    min_size     = number
    max_unavailable = number
  })
}

variable "csi_driver" {
  description = "Allows pvc from ebs on aws"
  type = object({
    addon_version = string
    role_name = string
  })
}