terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }

  // change the state file storage place to s3
  backend "s3" {
    bucket = "daniel-managed-36236"
    key    = "terraform.tfstate"
    region = "eu-west-3"
  }
}

provider "aws" {
  region = var.region
  
  default_tags {
    tags = {
      Owner           = "Daniel Yakov"
      bootcamp        = "17"
      expiration_date = "01-04-2023"
    }
  }
}