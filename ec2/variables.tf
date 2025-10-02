variable "packer_channel" {
  type = string
}

variable "region" {
  type = string
}

variable "packer_instance_profile_name" {
  type        = string
  description = "The name of the instance profile used by Packer."
}

variable "sg_id" {
  type = string
}

variable "num_instances" {
  type        = number
  description = "The number of Packer build instances to launch. If greater than the number of subnets, the number of subnets will be used."
}

variable "project_name" {
  type        = string
  description = "Unique prefix for AWS resources to avoid conflicts."
}
