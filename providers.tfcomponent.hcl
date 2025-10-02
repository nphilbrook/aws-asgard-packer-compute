required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 6.4"
  }
  hcp = {
    source  = "hashicorp/hcp"
    version = "~> 0.109"
  }
}

provider "aws" "configurations" {
  for_each = var.regions

  config {
    region = each.value

    assume_role_with_web_identity {
      role_arn           = var.role_arn
      web_identity_token = var.identity_token_aws
    }

    default_tags {
      tags = var.default_tags
    }
  }
}

provider "hcp" "this" {
  config {
    workload_identity {
      resource_name = var.hcp_wip
      token         = var.identity_token_hcp
    }
  }
}
