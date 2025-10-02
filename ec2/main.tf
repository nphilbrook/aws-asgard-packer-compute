# Create AWS keypair
resource "aws_key_pair" "shared" {
  key_name   = "${var.project_name}-shared-${var.packer_channel}"
  public_key = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC48Ys2HvlHglzLbwdfxt9iK2LATImoH8VG9vWzvuiRIsa8UQxbLbk6Gutx3MpB2FZywB3ZrZfw5MqivAtJXE2Os/QmgAZQxRpV15BTzrgvbqTKyibKnmRsCG59O8icftREKY6q/gvzr67QcMhMEZLDExS8c+zycQT1xCVg1ip5PwPAwMQRxtqLvV/5B85IsJuMZi3YymYaVSJgayYBA2eM/M8YInlIDKNqekHL/cUZFG2TP98NOODsY4kRyos4c8+jkULLCOGu0rLhA7rP3NsvEbcpCOI2lS5XgxnOHIpZ42V2xGId8IRDtK4wEGAHEWmOKdOsL4Qe5AwglHMmdkZU2HKdThOb5+8pf5BDe/I9aLB3k7vW5jcOm1dyHZ0pg/Tg9hJdFCCSBm0E4EJDRzI223chgwjf+XrMDB7DHTa29KU63rDeQme89y57HkgxXCIq4EVUKRaJS1PIUI7uJKMDryd2Au/W9z4nAbindFIxHMg/eC1aW0k90ri8FebvkX0= acme_corp_briefing.pub
EOF
}

data "hcp_packer_artifact" "packer" {
  bucket_name  = "packer-build"
  channel_name = var.packer_channel
  platform     = "aws"
  region       = var.region
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}"]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-public-${var.region}*"]
  }
}

resource "aws_instance" "packer" {
  for_each                    = toset(slice(data.aws_subnets.subnets.ids, 0, min(var.num_instances, length(data.aws_subnets.subnets.ids))))
  ami                         = data.hcp_packer_artifact.packer.external_identifier
  associate_public_ip_address = true # Allow initial dynamic IP, will be replaced by EIP
  iam_instance_profile        = var.packer_instance_profile_name
  instance_type               = local.packer_instance_type
  key_name                    = aws_key_pair.shared.key_name
  vpc_security_group_ids      = [var.sg_id]
  subnet_id                   = each.key

  metadata_options {
    http_tokens = "required"
  }

  tags = { Name = "${var.project_name}-packer-${var.packer_channel}-${var.region}" }
}

# Create Elastic IP addresses for static IP assignment
resource "aws_eip" "packer" {
  for_each = aws_instance.packer
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-packer-eip-${var.packer_channel}-${var.region}-${substr(each.key, -4, 4)}"
  }
}

# Associate Elastic IPs with instances
resource "aws_eip_association" "packer" {
  for_each      = aws_instance.packer
  instance_id   = each.value.id
  allocation_id = aws_eip.packer[each.key].id
}

# Packer SG - this security group ID
# should be provided to packer build templates
# so that the packer hosts can access them
resource "aws_security_group" "packer_ssh_ingress" {
  vpc_id      = data.aws_vpc.vpc.id
  name        = "${var.project_name}-packer-ingress-${var.packer_channel}"
  description = "Allow SSH traffic from the Packer build hosts to the build instances"
}

resource "aws_vpc_security_group_ingress_rule" "packer_ssh" {
  for_each = aws_eip.packer

  security_group_id = aws_security_group.packer_ssh_ingress.id

  cidr_ipv4   = "${each.value.public_ip}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "packer_egress" {
  security_group_id = aws_security_group.packer_ssh_ingress.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}
