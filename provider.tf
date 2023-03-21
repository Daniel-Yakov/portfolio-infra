terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.17.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.8.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }

  // change the state file storage place to s3
  backend "s3"{
    bucket = "daniel-managed-36236"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
  
  default_tags {
    tags = {
      Owner           = "Daniel Yakov"
    }
  }
}

provider "kubernetes" {
    host                   = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}