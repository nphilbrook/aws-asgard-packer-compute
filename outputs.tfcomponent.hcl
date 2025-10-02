output "packer_public_dns" {
  type  = list(list(string))
  value = [for c in component.ec2 : c.packer_public_dns]
}

output "packer_instance_profile_role_arn" {
  type  = list(string)
  value = [for c in component.iam : c.instance_profile_role_arn]
}

output "packer_ssh_ingress_sg_ids" {
  type  = list(string)
  value = [for c in component.ec2 : c.packer_ssh_ingress_sg_id]
}
