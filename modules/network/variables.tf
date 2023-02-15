###### required ######
# vpc.tf vars
variable "vpc_name" {
  description = "The name of the vpc"
  type = string
}

# subnets.tf vars
variable "subnets_name" {
  description = "Name of subnets"
  type        = list(string)
}

###### optional/defualt ######
# vpc.tf vars
variable "vpc_cidr_block" {
  description = "VPC's cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

# subnets.tf vars
variable "subnet_cidr_block" {
  description = "Subnet's cidr block"
  type        = list(string)
  default     = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

