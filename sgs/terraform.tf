terraform {
  required_version = "~>1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.4"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">=0.107"
    }
  }
}
