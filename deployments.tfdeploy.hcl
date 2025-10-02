store "varset" "aws_auth" {
  name     = "aws-auth-philbrook-aws-packer-compute"
  category = "env"
}

store "varset" "hcp_auth" {
  name     = "hcp-auth-aws-packer"
  category = "env"
}

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

identity_token "hcp" {
  audience = ["hcp.workload.identity"]
}

locals {
  default_tags = {
    "created-by"   = "terraform"
    "source-stack" = "aws-asgard-packer-compute"
  }
}

deployment "dev" {
  inputs = {
    regions              = ["us-east-1"]
    identity_token_aws   = identity_token.aws.jwt
    role_arn             = store.varset.aws_auth.TFC_AWS_RUN_ROLE_ARN
    identity_token_hcp   = identity_token.hcp.jwt
    hcp_wip              = store.varset.hcp_auth.TFC_HCP_RUN_PROVIDER_RESOURCE_NAME
    packer_channel       = "dev"
    default_tags         = local.default_tags
    project_name         = "asgard"
    num_packer_instances = 1
  }
}

publish_output "dev_packer_public_dns" {
  value = deployment.dev.packer_public_dns
}

publish_output "dev_packer_instance_profile_role_arn" {
  value = deployment.dev.packer_instance_profile_role_arn
}

deployment "qa1" {
  inputs = {
    regions            = ["us-east-1"]
    identity_token_aws = identity_token.aws.jwt
    role_arn           = store.varset.aws_auth.TFC_AWS_RUN_ROLE_ARN
    identity_token_hcp = identity_token.hcp.jwt
    hcp_wip            = store.varset.hcp_auth.TFC_HCP_RUN_PROVIDER_RESOURCE_NAME
    packer_channel     = "qa1"
    default_tags       = local.default_tags
    project_name       = "asgard"
  }
}


deployment "sit" {
  inputs = {
    regions            = ["us-east-1"]
    identity_token_aws = identity_token.aws.jwt
    role_arn           = store.varset.aws_auth.TFC_AWS_RUN_ROLE_ARN
    identity_token_hcp = identity_token.hcp.jwt
    hcp_wip            = store.varset.hcp_auth.TFC_HCP_RUN_PROVIDER_RESOURCE_NAME
    packer_channel     = "sit"
    default_tags       = local.default_tags
    project_name       = "asgard"
  }
}

deployment "prod" {
  inputs = {
    regions              = ["us-east-1"]
    identity_token_aws   = identity_token.aws.jwt
    role_arn             = store.varset.aws_auth.TFC_AWS_RUN_ROLE_ARN
    identity_token_hcp   = identity_token.hcp.jwt
    hcp_wip              = store.varset.hcp_auth.TFC_HCP_RUN_PROVIDER_RESOURCE_NAME
    packer_channel       = "prod"
    default_tags         = local.default_tags
    project_name         = "asgard"
    num_packer_instances = 2
  }
}

publish_output "prod_packer_public_dns" {
  value = deployment.prod.packer_public_dns
}

publish_output "prod_packer_instance_profile_role_arn" {
  value = deployment.prod.packer_instance_profile_role_arn
}
