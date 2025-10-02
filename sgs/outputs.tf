output "allow_all_sg_id" {
  value = aws_security_group.allow_all.id
}

output "allow_ssh_egress_sg_id" {
  value = aws_security_group.allow_ssh_egress.id
}
