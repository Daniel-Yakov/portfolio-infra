// provider
variable "region" {
  description = "The aws region"
  type = string
  default = "eu-west-3"
}

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

variable "cluster_name" {
  type        = string
  default     = "daniel-portfolio-cluster"
  description = "EKS cluster name"
}

variable "node_group_name" {
  type        = string
  default     = "daniel-portfolio-nodegroup"
  description = "Node group name"
}

variable "desired_size" {
  type        = number
  default     = 2
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

variable "namespace" {
  type = string
  default = "security"
  description = "Namespace for the sealed secrets to be deployed"
}