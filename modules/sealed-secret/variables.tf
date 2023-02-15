variable "namespace" {
  type = string
  description = "Namespace for the sealed secrets to be deployed"
}

variable "sealed_secrets_key_name" {
  type = string
  description = "Name of the sealed secret key"
}