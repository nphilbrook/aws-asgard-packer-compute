variable "packer_channel" {
  type = string
}

variable "project_name" {
  type        = string
  description = "Unique prefix for AWS IAM resources to avoid conflicts."
}
