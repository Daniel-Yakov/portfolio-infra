variable "cert_manager_solver_role_name" {
  type = string
  description = "Name of the Role that will allow cert manager to resolve the tls challenge"
}

variable "node_group_role_arn" {
  type = string
  description = "node group role arn"
}

variable "hosted_zone_id" {
  type = string
  description = "id of the hosted zone"
}