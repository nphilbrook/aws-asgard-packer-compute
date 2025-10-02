output "packer_instance_profile_name" {
  value = aws_iam_instance_profile.packer_profile.name
}

output "instance_profile_role_arn" {
  value       = aws_iam_role.packer_role.arn
  description = "The AWS IAM Role ARN for the instance profile used by Packer."
}
