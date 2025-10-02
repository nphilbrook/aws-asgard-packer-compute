locals {
  # A convenience variable to determine if we are in a dev or prod channel
  # EC2 VMs and IAM resources are only created for those channels/envs.
  dev_prod_channels = toset(contains(["dev", "prod"], var.packer_channel) ? ["_"] : [])
}

component "iam" {
  for_each = local.dev_prod_channels
  source   = "./iam"

  inputs = {
    packer_channel = var.packer_channel
    project_name   = var.project_name
  }

  providers = {
    # IAM resources are global - is there a better way to do this other than hardcoding?
    aws = provider.aws.configurations["us-east-1"]
  }
}

component "sgs" {
  source = "./sgs"

  for_each = var.regions

  inputs = {
    packer_channel  = var.packer_channel
    region          = each.value
    source_ip_cidrs = var.source_ip_cidrs
    project_name    = var.project_name
  }

  providers = {
    aws = provider.aws.configurations[each.value]
  }
}

component "ec2" {
  for_each = local.dev_prod_channels
  source   = "./ec2"

  inputs = {
    packer_channel               = var.packer_channel
    region                       = "us-east-1"
    packer_instance_profile_name = component.iam["_"].packer_instance_profile_name
    sg_id                        = component.sgs["us-east-1"].allow_ssh_egress_sg_id
    num_instances                = var.num_packer_instances
    project_name                 = var.project_name
  }

  providers = {
    aws = provider.aws.configurations["us-east-1"]
    hcp = provider.hcp.this
  }
}
