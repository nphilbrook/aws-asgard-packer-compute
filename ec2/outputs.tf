output "packer_public_dns" {
  value = [for eip in aws_eip.packer : eip.public_dns]
}

output "packer_public_ips" {
  description = "Static public IP addresses of the Packer instances"
  value       = [for eip in aws_eip.packer : eip.public_ip]
}

output "packer_ssh_ingress_sg_id" {
  value = aws_security_group.packer_ssh_ingress.id
}
