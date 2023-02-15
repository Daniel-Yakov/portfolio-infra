variable "eks_cluster_name" {
  type = string
  description = "cluster name"
}

variable "subnets" {
  type = list(string)
  description = "cluster subnets"
}

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

variable "csi_driver" {
  type = object({
    addon_version = string
    role_name = string
  })
  description = "Allows pvc from ebs on aws"
}