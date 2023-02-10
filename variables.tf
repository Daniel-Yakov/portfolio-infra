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

variable "az_list" {
  type        = list(string)
  default     = [ "eu-west-3a", "eu-west-3b" ]
  description = "list of AZ to create"
}
