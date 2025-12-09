variable "regions" {
  type = set(string)
}

variable "identity_token_aws" {
  type      = string
  ephemeral = true
}

variable "role_arn" {
  type      = string
  ephemeral = true
}

variable "identity_token_hcp" {
  type      = string
  ephemeral = true
}

variable "hcp_wip" {
  type      = string
  ephemeral = true
}

variable "default_tags" {
  description = "A map of default tags to apply to all AWS resources"
  type        = map(string)
  default     = {}
}

variable "packer_channel" {
  type        = string
  description = "The Packer channel to use for the build"
}

variable "num_packer_instances" {
  type        = number
  description = "The number of Packer build instances to launch. If greater than the number of subnets, the number of subnets will be used."
  default     = 0
}

variable "source_ip_cidrs" {
  type        = list(string)
  description = "A list of IPv4 CIDRs that will allow SSH ingress to the packer hosts as well as HTTP and HTTPS ingress to the demo web hosts."
  default     = ["71.168.85.118/32"]
}

variable "project_name" {
  type        = string
  description = "Unique prefix for AWS resources to avoid conflicts."
}
