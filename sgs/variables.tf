variable "packer_channel" {
  type = string
}

variable "region" {
  type = string
}

variable "source_ip_cidrs" {
  type        = list(string)
  description = "A list of IPv4 CIDRs that will allow SSH ingress to the packer hosts as well as HTTP and HTTPS ingress to the demo web hosts."
  default     = []
}

variable "project_name" {
  type        = string
  description = "Unique prefix for AWS resources to avoid conflicts."
}
