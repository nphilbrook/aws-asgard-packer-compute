data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}"]
  }
}

# default allow all
resource "aws_security_group" "allow_all" {
  vpc_id      = data.aws_vpc.vpc.id
  name        = "${var.project_name}-allow-all-${var.packer_channel}"
  description = "Allow all HTTP and SSH traffic and all egress traffic"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.source_ip_cidrs)

  security_group_id = aws_security_group.allow_all.id

  cidr_ipv4   = each.value
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  for_each = toset(var.source_ip_cidrs)

  security_group_id = aws_security_group.allow_all.id

  cidr_ipv4   = each.value
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each = toset(var.source_ip_cidrs)

  security_group_id = aws_security_group.allow_all.id

  cidr_ipv4   = each.value
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "all_egress" {
  security_group_id = aws_security_group.allow_all.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}
# end default allow all

# default allow SSH/egress
resource "aws_security_group" "allow_ssh_egress" {
  vpc_id      = data.aws_vpc.vpc.id
  name        = "${var.project_name}-allow-ssh-egress-${var.packer_channel}"
  description = "Allow all SSH traffic and all egress traffic"
}

resource "aws_vpc_security_group_ingress_rule" "ssh2" {
  for_each = toset(var.source_ip_cidrs)

  security_group_id = aws_security_group.allow_ssh_egress.id

  cidr_ipv4   = each.value
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "all_egress2" {
  security_group_id = aws_security_group.allow_ssh_egress.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}
# end default allow SSH/egress
